class AAUDKAweGame_Aggressive_BeamEmitter extends AAUDKAweGame_Aggressive
    placeable;

enum HitType
{
    HT_HitDamege,
    HT_HitBack,
    HT_HitAll,
};

var() HitType BeamHitType;

var() int BumpDamege;

// ��������ϵͳģ��
var particleSystem BeamTemplate;

// �����˹������ӷ�����
var ParticleSystemComponent BeamEmitter;

//���߷����Ĳ�۵�name
var name BeamSockets;

/*����ʱû�У�
// ���䶯����name
var name	BeamPreFireAnim;
var name	BeamFireAnim;
var name	BeamPostFireAnim;
*/
//�Ƿ�����
var() bool bCanOpen;

//�������ֵ��ƥ����ͬ�Ľ�����
var() int  MatchingReceiver;

var() AAUDKAweGame_Aggressive_BeamReceiver m_Receiver;

var bool bFire;

//ģ��
var SkeletalMeshComponent MyMesh;

var vector AimLocation;

auto state noOpen
{
    function BeginState(Name PreviousStateName)
    {
        //��ӷ�����
        AddBeamEmitter();
    }

    event Tick(float DeltaTime)
    {
        if(bCanOpen == true)
			GoToState('Open');
    }
}

state Open
{
    function BeginState(Name PreviousStateName)
    {
        StartBeamEmitter();
		SetTimer(3,true,'TimerFindTheBeamReceiver');
    }
    event Tick(float DeltaTime)
    {
        //SetRotation(rotator(AimLoation - Location)  + rot(0,90,0) );
        //`log(AimLocation - Location);
        BeamEmitter.SetVectorParameter('LinkBeamEnd',m_Receiver.Location);
        GetTheTrace();
    }
}

function GetTheTrace()
{
    local Vector HitLocation, HitNormal ,StartLocation;
    local Rotator mRotator;
    local Actor	HitActor;
    local bool CanTakeDamage;
    local Vector Momentum;

    //��ȡ��۵������
    MyMesh.GetSocketWorldLocationAndRotation('Muzzle',StartLocation,mRotator);

    HitActor = Trace(HitLocation, HitNormal, m_Receiver.Location, StartLocation,true,vect(0,0,0));
    //HitActor = Trace(AimLocation, StartLocation,false);
    if(HitActor == none)
        return;

	`log("HitActorHitActorHitActor" @ HitActor);
    //���������
    if(HitActor != none && AAUDKAweGame_Pawn(HitActor) != none)
    {
        //�ж��Ƿ�һ��ʱ���ڲ��ɴ���
        CanTakeDamage = IsCanTakeDamageAgain(HitActor);
        if(CanTakeDamage)
        {
            //����Momentum
            SetActorVelocity(HitActor,Momentum);
            HitActor.TakeDamage(BumpDamege, none, Location ,Momentum,class'UTDmgType_LinkPlasma',,self);
        }		
    }  
	//����д�������壬���߲��ᴩ͸
		if(HitActor != none)
			BeamEmitter.SetVectorParameter('LinkBeamEnd',HitLocation);
}



function AddBeamEmitter()
{
	if(BeamTemplate != None)
	{
        BeamEmitter = new(Outer) class'UTParticleSystemComponent';
        BeamEmitter.bUpdateComponentInTick = true;
        BeamEmitter.SetTemplate(BeamTemplate);
		BeamEmitter.SetDepthPriorityGroup(SDPG_World);
		BeamEmitter.SetTickGroup( TG_PostUpdateWork );

		MyMesh.AttachComponentToSocket( BeamEmitter,'Muzzle');

		BeamEmitter.ActivateSystem();
		BeamEmitter.SetVectorParameter('LinkBeamEnd',Location);
		BeamEmitter.SetHidden(True);
	}
}

//���Ʒ���������
function StartBeamEmitter()
{
	FindTheBeamReceiver();
}

//��ʱ�������н�����
function TimerFindTheBeamReceiver()
{
	if(FindTheBeamReceiver())
		ClearTimer('TimerFindTheBeamReceiver');
}

//�������н�����
function bool FindTheBeamReceiver()
{
    Local AAUDKAweGame_Aggressive_BeamReceiver BR;

    if(!bCanOpen && MatchingReceiver == 0)
        return false;
    //�������н�������ƥ��
    foreach DynamicActors(class'AAUDKAweGame_Aggressive_BeamReceiver', BR)
    {
        if(BR != none && BR.MatchingEmitter == MatchingReceiver)
        {
			m_Receiver = BR;
            AimLocation = m_Receiver.Location;
			BeamEmitter.SetHidden(false);
			return true;
        }
    }
	return false;
}

//�ı�Ӵ�֮��Ӧ(�ص�֮���)(��д����)
function SetActorVelocity(Actor HitActor,out Vector out_momentum)
{
    if(HitActor == none)
    {
        `log("SetActorVelocity's TakeDamageActor == none" );
        return;
    }
    if(BeamHitType == HT_HitBack || BeamHitType == HT_HitAll)
    {

        out_momentum = HitActor.velocity * -200;
        out_momentum.x *= 0.25;
        out_momentum.y *= 0.8;
        if(HitActor.Physics == PHYS_Falling)
        {
            out_momentum *= 0.3;
        }
        out_momentum += vect(0,0,30000);
        HitActor.velocity = vect(0,0,0);

        //TakeDamageActor.velocity *= MoveVelocityMultiple;


        //TakeDamageActor.velocity.x *= 0.25;

        //if (TakeDamageActor.Physics == PHYS_Falling)
           // TakeDamageActor.velocity *= 0.3;
    }
}

defaultproperties
{
    //���������
    Begin Object Class=SkeletalMeshComponent Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'KismetGame_Assets.Anims.SK_JazzGun'
    End Object
    MyMesh=FirstPersonMesh
    Components.Add(FirstPersonMesh)

    //���������
    BeamTemplate=ParticleSystem'Awe_Beam.Effects.Awe_Laser'

    BeamSockets=fashekou

    bCanOpen=false
    bFire=false
    MatchingReceiver=0
    BeamHitType=1
    BumpDamege=10
    InvulnerableTime=2.0

	Physics=PHYS_Interpolating
    

}


