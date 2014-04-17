class AAUDKAweGame_Monster extends UDKPawn
    placeable;

var float BumpDamage;
var Pawn Enemy;
var float AttackDistance;
var float MovementSpeed;
var bool bAttacking;

//�ٶȿ���(��Ҫ��ֵ��GroudSpeed��)
var float SpeedRate;
var float LatendGroundSpeed;

//AI�Ŀ�����
var class<AIController> NPCController;

//������������������
var AAUDKAweGame_MonsterSpawner MyMonsterSpawner;

var Material SeekingMat, AttackingMat, FleeingMat;

//�������˺�
var bool bCanTakeDamage;
var bool bTakeDamaging;
var bool bDied;

//�Զ��嶯���ڵ�
var AnimNodePlayCustomAnim CustomAnim;
var AnimNodeSequence CurSeqNode;
//�ڵ㶯��name
var name StandAnimNodeName;
var name MoveAnimNodeName;
var name AtkAnimNodeName;
var name DamageAnimNodeName;
var name DeathAnimNodeName;

var AAUDKAweGame_BuffSocket BuffSocket;


// ��������ϵͳģ��
var particleSystem ParticleTemplate;
// �����˹������ӷ�����
var ParticleSystemComponent ParticleEmitter;

//������ԭ��
var() const archetype AAUDKAweGame_MonsterProperties PropertiesArchetype;
var() AAUDKAweGame_MonsterProperties m_MonsterProperties;

var name ThisMonsterName;
struct MonsterInfo_A
{
    var int Match;
    var name MonsterName;
};

var MonsterInfo_A MonsterInfo;


/*************************** ��ʼ���͹��� **************************/

simulated event PostBeginPlay()
{
    //����������ָ�ֵ
    MonsterInfo.MonsterName = ThisMonsterName;
    if(NPCController != none)
    {
        //set the existing ControllerClass to our new NPCController class
        //Controller = Spawn(class'UDNBot', self);
        ControllerClass = NPCController;
    }
    Super.PostBeginPlay();
    //����Controller
    if(Controller == none)
    {
        Controller = Spawn(ControllerClass);
        Controller.Possess(self,false);
		`log("Controller@@@@@@@HHHHHHHHHHHHHHHHHHHHHHHHHH" @ Controller.Pawn);
    }

	if(!ConnectMonsterProperties())
		`log("Connect Monster Properties false PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");

	InitBuffSocket();
}

function InitBuffSocket()
{
	BuffSocket = Spawn(Class'AAUDKAweGame_BuffSocket');
	BuffSocket.InitOwner(self);
}

//���ӹ�������
function bool ConnectMonsterProperties()
{
	if(PropertiesArchetype != none)
	{
		m_MonsterProperties = new(Outer) PropertiesArchetype.Class;
		m_MonsterProperties.OwnerPawn = self;
		m_MonsterProperties.InitForPawn();
		`log("GroudSpeed" @ GroundSpeed);
		return true;
	}
	return false;
}


function SetMyMonsterSpawner(AAUDKAweGame_MonsterSpawner MonsterSpawner)
{
    MyMonsterSpawner = MonsterSpawner;
}

/*************************** takedamage **************************/

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
vector Momentum, class<DamageType> DamageType,optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Controller Killer;
    //super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	

	Health -= DamageAmount;

	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
	{
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	}
	momentum = momentum/Mass;

	if ( Health <= 0 )
	{
		// pawn died
		Killer = SetKillInstigator(EventInstigator, DamageType);
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		HandleMomentum( momentum, HitLocation, DamageType, HitInfo );
	}

	//��ǰ�����ܵ��˺�
	bTakeDamaging=true;
	SetTimer(1,false,'TakeDamageEnd');

	if(CheckThisActionIsBreak())
	{
		if(GetStateName() != 'Dying' && bDied == false)
		{
			`log("PlayDamage");
			if(CustomAnim != none && m_MonsterProperties != none)
				PlayMonsterAnim(DamageAnimNodeName,m_MonsterProperties.AtkSpeed,,,false,true,true);
		}
	}
	else
	{
		//��ͣ����
		PauseAnim();
	}

	if(Owner != none)
	{
		if(Owner.GetStateName() == 'Standing' || Owner.GetStateName() == 'Hover')
		{
			Owner.GotoState('GoToAttack');
		}
	}
	SetPhysics(PHYS_None);
}

function TakeDamageEnd()
{
	bTakeDamaging=false;
}

function SendBuffToTargetPawn(Actor TargetPawn,class<AAUDKAweGame_Buff> buff,AAUDKAweGame_Properties MyPro)
{
	if(AAUDKAweGame_Pawn(TargetPawn) != none)
		AAUDKAweGame_Pawn(TargetPawn).BuffSocket.CreateBuff(buff,self);
	if(AAUDKAweGame_Monster(TargetPawn) != none)
		AAUDKAweGame_Monster(TargetPawn).BuffSocket.CreateBuff(buff,self);
}

//��ȡ��۵�����
function Vector GetHitSocketLocation(Name SocketName)
{
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;

	SMC = Mesh;

	if (SMC != none && SMC.GetSocketByName(SocketName) != none)
	{
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}

	return SocketLocation;
}

/*************************** �ٶȿ��� ***************************/

//�����ƶ��ٶȱ��ʵ����Ӻͼ���
function SetSpeedRateByMoreOrLess(float add)
{
	if(SpeedRate < 0)
		return;
	SpeedRate+=add;
	UpdateGroundSpeed();
}

//�����ƶ��ٶ����ֵ
function SetLatendGroundSpeed(float Speed)
{
	if(Speed < 0)
		return;
	LatendGroundSpeed = Speed;
	UpdateGroundSpeed();
}

//���µ�ǰ�ƶ��ٶ�
function UpdateGroundSpeed()
{
	GroundSpeed = LatendGroundSpeed * SpeedRate;
}

event Tick(float DeltaTime)
{
	//����������ͣһ��
	if(bTakeDamaging)
	{
		velocity = vect(0,0,0);
	}
}


/*************************** ���Ŷ��� *******************************/

//��ͣ����
function PauseAnim()
{
	Mesh.bPauseAnims = true;
	SetTimer(1,false,'ContinuePlayAnim');
}

//��������
function ContinuePlayAnim()
{
	Mesh.bPauseAnims = false;
	//CurSeqNode.PlayAnim(CurSeqNode.bLooping,1,CurSeqNode.CurrentTime);
}

//���Ŷ���
function PlayMonsterAnim(name AnimNodeName,float AnimRate ,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	bool	bOverride,
	optional bool bIsCauseActorAnimEnd = false)
{
	if(AnimNodeName == '' || CustomAnim == none)
		return;
	CustomAnim.PlayCustomAnim(AnimNodeName,AnimRate,BlendInTime,BlendOutTime,bLooping,bOverride);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = bIsCauseActorAnimEnd;
}
/*
//վ��
function PlayStand()
{
	
}

//����
function PlayMove()
{
	
}

//����
function PlayDamage()
{
	
}

//����
function PlayDeath()
{
	
}

//����׼��
function PlayAttReady()
{

}

//����
function PlayAtt()
{

}*/

simulated event OnAnimEnd(AnimNodeSequence SeqNode,float PlayedTime,float ExcessTime)
{
	
}

function bool CheckThisActionIsBreak()
{
	return true;
}

/*****************************************************/

state Dying
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);

		MyMonsterSpawner.EnemyDied();

		//������������
		if(CustomAnim != none && m_MonsterProperties != none)
		{
			if(DeathAnimNodeName != '')
				PlayMonsterAnim(DeathAnimNodeName,m_MonsterProperties.AtkSpeed,,100,false,false,true);
		}
	}
}
/*********************** ���������Ч **********************/

function AddBeamEmitter(name socket)
{
	if(ParticleTemplate != None)
	{
        ParticleEmitter = new(Outer) class'UTParticleSystemComponent';
        ParticleEmitter.bUpdateComponentInTick = true;
        ParticleEmitter.SetTemplate(ParticleTemplate);

		ParticleEmitter.SetDepthPriorityGroup(SDPG_World );
		ParticleEmitter.SetTickGroup( TG_PostUpdateWork );

		Mesh.AttachComponentToSocket( ParticleEmitter,socket);

		//BeamEmitter.ActivateSystem();
		ParticleEmitter.SetVectorParameter('LinkBeamEnd',vect(0,0,0));
		ParticleEmitter.SetHidden(true);
	}
}

defaultproperties
{
	bCanBeBaseForPawns=true
/*
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		bUseBooleanEnvironmentShadowing=false
	End Object
	Components.Add(MyLightEnvironment)*/
	//LightEnvironment=MyLightEnvironment
/*
    Begin Object Class=StaticMeshComponent Name=EnemyMesh
      StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
      //Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
      LightEnvironment=MyLightEnvironment
      Scale3D=(X=0.25,Y=0.25,Z=0.5)
    End Object
    Components.Add(EnemyMesh)
    MyMesh=EnemyMesh*/

    BumpDamage=5.0
    AttackDistance=96.0
    //MovementSpeed=256.0;
/*
    SeekingMat=Material'EditorMaterials.WidgetMaterial_X'
    AttackingMat=Material'EditorMaterials.WidgetMaterial_Z'
    FleeingMat=Material'EditorMaterials.WidgetMaterial_Y'*/

    NPCController=class'AAUDKAweGame_MonsterController'
    
    bDied=false
    ThisMonsterName="fangkuai"
    
    bBlockActors=True
    bCollideActors=True
    //MonsterInfo.MonsterName="fangkuai"

	bCanTakeDamage=true

	SpeedRate=1
	LatendGroundSpeed=100

	DamageAnimNodeName="fdfdfdf"

	DeathAnimNodeName=""

	PropertiesArchetype=AAUDKAweGame_MonsterProperties'Awe_Monster.MonsterPro.BasePro'
}