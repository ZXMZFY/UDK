class AAUDKAweGame_MonsterController extends UTBot;

var Actor Destination;

//�ǻ�״̬��Ҫȥ��Ŀ��
var vector MoveToTargetLocal;

//�ǻ���Χ
var int HoverSightRange;
//�������м�ⷶΧ
var() int PawnAttSightRange;
var bool bHasEnemyInSightRange;

//���з�Χ(��������ս��)
var bool bHasAOutFightTimer;
var() int SpawnerSightRange;
var() int OutFightTime;

//�Ƿ���ս��״̬
var int AttSightRange;
var bool bIsFight;

//���ڼ�¼һ�ι����Ĺ֣������ظ��˺�
var array<Actor> HitActors;

//��ǰ��Ҫ�ƶ�ȥ�ĵط�
var Actor TargetA;
var vector tempLocation;

simulated function PostBeginPlay()
{
	Enemy = GetEnemy();
    super.PostBeginPlay();
	SetTimer(2,false,'ExecuteWhatToDoNext');
}

protected event ExecuteWhatToDoNext()
{
  //Go to the roaming state
  GotoState('Standing');
  `log("GotoState Standing");
}

function Pawn GetEnemy()
{
    local PlayerController PC;
    local Pawn MyEnemy;
    foreach LocalPlayerControllers(class'PlayerController', PC)
    {
        if(PC.Pawn != none)
            MyEnemy = PC.Pawn;
    }
    return MyEnemy;
}

event HearNoise(float Loudness, Actor NoiseMaker, optional Name NoiseType )
{

}

/*************************** ״̬���� **************************/

//վ��״̬
state Standing
{
    function BeginState(Name PreviousStateName)
    {
        //��һ�����ʽ����ǻ�״̬
        SetTimer(2,true,'IfGoHover');
		//BookChildMonster(Pawn).PlayDeath();

		AAUDKAweGame_Monster(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster(Pawn).StandAnimNodeName,
			AAUDKAweGame_Monster(Pawn).m_MonsterProperties.AtkSpeed,,,true,true,false);
        
		`log("go to Standing!!!!!!!!!!!!!!!!!");
    }

    function Tick(float DeltaTime)
    {
		//�������Ƿ���ڣ�û�����ȡ
		if(Enemy == none)
			Enemy = GetEnemy();
		//�������Ƿ��ڷ�Χ��
		if(CheckEnemyInSightRange() == true)
		{
			//�����ڹ�����Χ��
			`log("Go To Attack");
			GoToState('GoToAttack');
		}
    }
    
    //��һ�����ʽ����ǻ�״̬
    function IfGoHover()
    {
        local int odds;
        //����Ƿ�����ǻ�

        odds = Rand(100);
        if(odds < 50)
        {
            GotoState('Hover');
        }
    }

    function EndState(Name PreviousStateName)
    {
        //�����ʱ��
        ClearTimer('IfGoHover');
    }
}

//�ǻ�״̬
state Hover
{
    function BeginState(Name PreviousStateName)
    {

        //�趨�ǻ����ĸ�λ��
        Local vector OffsetLocal;
		//����
        AAUDKAweGame_Monster(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster(Pawn).MoveAnimNodeName,
			AAUDKAweGame_Monster(Pawn).m_MonsterProperties.AtkSpeed,,,true,true,false);
        //���������ĵ�����300��Χ�ڵĵ�
        OffsetLocal.x = HoverSightRange - Rand(HoverSightRange*2);
        OffsetLocal.y = HoverSightRange - Rand(HoverSightRange*2);

        MoveToTargetLocal = AAUDKAweGame_Monster(Pawn).MyMonsterSpawner.Location + OffsetLocal;
		`log("MoveToTargetLocal" @ MoveToTargetLocal);
    }

    function Tick(float DeltaTime)
    {
		//����Ƿ������з�Χ��
		if(CheckEnemyInSightRange())
			GotoState('GoToAttack');
    }

    event ReachedPreciseDestination()
	{
		`log("Has Reached");
		GotoState('Standing');
	}

Begin:
    //ȥ�Ǹ�����
    MoveTo(MoveToTargetLocal);
    //bPreciseDestination = true;
}

state GoToAttack
{
	function BeginState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster(Pawn).MoveAnimNodeName,
			AAUDKAweGame_Monster(Pawn).m_MonsterProperties.AtkSpeed,,,true,true,false);
		bIsFight = true;		
    }

	function WhatToDoNext()
	{
		GotoState('GoToAttack','Begin');

	}

	function Tick(float DeltaTime)
    {
		//����Ƿ�������ս��
		if(CheckEnemyIsInSpawnerSightRange())
		{
			bHasAOutFightTimer=false;
			ClearTimer('SetTheMonsterOutFight');
			return;
		}
		else
		{
			if(!bHasAOutFightTimer)
			{
				bHasAOutFightTimer = true;
				SetTimer(OutFightTime,false,'SetTheMonsterOutFight');
			}
		}
	}
	event ReachedPreciseDestination()
	{
		`log("bPreciseDestination");
		GotoState('GoToAttack','Begin');
	}


	function EndState(Name PreviousStateName)
    {
		//bPreciseDestination = true;
        //bIsFight=false;	
    }

Begin:
	TargetA = Enemy;
	NavigationHandle.SetFinalDestination(TargetA.Location);
	if(GeneratePathToA(TargetA) && NavigationHandle.GetNextMoveLocation( tempLocation, Pawn.GetCollisionRadius()))
	{
		Moveto(tempLocation);
		WhatToDoNext();
	}
	//��������±�����ʱ��ֹ׹��
	MovetoWard(TargetA);
	WhatToDoNext();
	//bPreciseDestination = true;
	/*//��ǰ��AIѰ·���������������������Ȼ����������
	A = Enemy;
	NavigationHandle.SetFinalDestination(A.Location);
	if( !NavigationHandle.ActorReachable( A) )
	{
		if( GeneratePathToA(A) )
		{
			`log("FindNavMeshPath returned TRUE");
			FlushPersistentDebugLines();
			NavigationHandle.DrawPathCache(,TRUE);
		}
		else
		{
			//give up because the nav mesh failed to find a path
			`warn("FindNavMeshPath failed to find a path to"@A);
			MoveToward(A);
			`log("FindNavMeshPath failed and move to");
			WhatToDoNext();
		}   
	}
	else
	{	
		MoveToward( A);	
		`log("MoveTo MoveTo MoveToMoveToMoveToMoveTo");
		WhatToDoNext();
	}
	
	while( Pawn != None && A != None && !Pawn.ReachedDestination(A))
	{
		`log(Pawn.ReachedDestination(A));
		if( NavigationHandle.GetNextMoveLocation( AA, Pawn.GetCollisionRadius()))
		{
			//AA.Z = Pawn.Location.Z;
			//`log("the path go to AA");
			if (!NavigationHandle.SuggestMovePreparation( AA,self))
			{
			    `log("Enemy.Location" @ Enemy.Location);
				`log("the path MOve move to AA" @ AA);
				
				MoveTo( AA );
				//bPreciseDestination = true;
				
			}
		}
		else
		{
			`log("breakbreakbreakbreakbreak");
			WhatToDoNext();			
		}
	}*/ //ͬ��
	//`log("WhatToDoNext");
	//GotoState('GoToAttack');
	//`log("GeneratePathToActor" @ GeneratePathToA(A));
	//`log("GetNextMoveLocation!!!!" @ NavigationHandle.GetNextMoveLocation(AA,10) );
	//SetDestinationPosition(AA);
	//NavigationHandle.SetFinalDestination(AA);
	//bPreciseDestination = true;
/*	//ȥ�Ǹ�����
	A = FindPathToward(Enemy,true);
	`log(A @ "A");
	if(A != none)
		MoveToward(A);
	else
		MoveToward(Enemy);*/
	//WhatToDoNext();
//bPreciseDestination = true;
}

state MoveHome
{
	function BeginState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster(Pawn).MoveAnimNodeName,
			AAUDKAweGame_Monster(Pawn).m_MonsterProperties.AtkRate,,,true,true,false);
		`log("In MoveHome");
		Pawn.Health = Pawn.HealthMax;
		AAUDKAweGame_Monster(Pawn).bCanTakeDamage = false;
    }

	event ReachedPreciseDestination()
	{
		`log("Has Reached");
	}

	function WhatToDoNext()
	{
		GotoState('Standing');
	}

	function EndState(Name PreviousStateName)
    {
        Pawn.Health = Pawn.HealthMax;
		AAUDKAweGame_Monster(Pawn).bCanTakeDamage = true;
    }

Begin:
//ȥ�Ǹ�����
	TargetA = AAUDKAweGame_Monster(Pawn).MyMonsterSpawner;
	NavigationHandle.SetFinalDestination(TargetA.Location);
	if(GeneratePathToA(TargetA) && NavigationHandle.GetNextMoveLocation( tempLocation, Pawn.GetCollisionRadius()))
	{
		Moveto(tempLocation);
	}
	else
		Moveto(TargetA.Location);
	WhatToDoNext();	
}

state Dead
{

Begin:
	if ( WorldInfo.Game.bGameEnded )
		GotoState('RoundEnded');
	Sleep(5);
TryAgain:
    if ( UTGame(WorldInfo.Game) == None )
		destroy();
	else
	{
		Sleep(0.75 + UTGame(WorldInfo.Game).SpaWnWait(self));
		//LastRespawnTime = WorldInfo.TimeSeconds;
		//WorldInfo.Game.ReStartPlayer(self);
		Goto('TryAgain');
	}
MPStart:
    Sleep(5);
    Sleep(0.75 + FRand());
	//WorldInfo.Game.ReStartPlayer(self);
	Goto('TryAgain');
}


/************************** ��Χ״̬��� **************************/
//Ѱ·ϵͳ
function bool GeneratePathToA(Actor Goal, optional float WithinDistance, optional bool bAllowPartialPath)
{
	if (NavigationHandle == None)
	{
         return false;
	}
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;

    // Set up the path finding
	class'NavMeshPath_Toward'.static.TowardGoal(NavigationHandle, Goal);
	class'NavMeshGoal_At'.static.AtActor(NavigationHandle, Goal, WithinDistance, bAllowPartialPath);
	// Set the path finding final destination
	//NavigationHandle.SetFinalDestination(Goal);
	// Perform the path finding
	return NavigationHandle.FindPath();
}

//����Ƿ��ڹ����׷����Χ��
function Bool CheckEnemyInSightRange()
{
	if(Enemy == none || Pawn == none)
		return false;
	return IsDistanceMinSize(Pawn.Location,Enemy.Location,PawnAttSightRange);
}
//��������Ƿ�����ս����Χ
function Bool CheckEnemyIsInSpawnerSightRange()
{
	if(Enemy == none || AAUDKAweGame_Monster(Pawn).MyMonsterSpawner == none)
		return false;
	return IsDistanceMinSize(AAUDKAweGame_Monster(Pawn).MyMonsterSpawner.Location,Enemy.Location,SpawnerSightRange);
}

//����Ƿ��ڹ�����Χ��
function bool CheckEnemyInAttSightRange()
{
	if(Enemy == none || Pawn == none)
		return false;
	return IsDistanceMinSize(Pawn.Location,Enemy.Location,AttSightRange);
}

//�����������Ƿ�С�ھ���
function bool IsDistanceMinSize(vector vector1,vector vector2,int Size)
{
	if(VSize(vector1 - vector2) <= Size)
		return true;
	else
		return false;
}

//һ�δ�����Ӵ��Ķ���
function bool AddToHitActors(Actor HitActor)
{
	local int i;

	for (i = 0; i < HitActors.Length; i++)
	{
		if (HitActors[i] == HitActor)
		{
			return false;
		}
	}

	HitActors.AddItem(HitActor);
	return true;
}
//ɾ������ôδ�������������
function RemoveHitActors()
{
	HitActors.Remove(0, HitActors.Length);
}

function SetTheMonsterOutFight()
{
	`log("go Home");
	GotoState('MoveHome');
}

/********** �ж����� ***********/
function StopMovement()
{
	local Vehicle V;

	if (Pawn.Physics != PHYS_Flying)
	{
		Pawn.Acceleration = vect(0,0,0);
	}
	V = Vehicle(Pawn);
	if (V != None)
	{
		V.Steering = 0;
		V.Throttle = 0;
		V.Rise = 0;
	}
}

function SendDamage(Actor Target,Controller tempInstigator,vector HitLoc,vector Momentum, class<DamageType> DamageType)
{
	Target.TakeDamage(10,tempInstigator,HitLoc,Momentum,DamageType);
}
	

/************** Tick *************/
function Tick(float DeltaTime)
{

}

defaultproperties
{
	HoverSightRange=300
	PawnAttSightRange=500
	SpawnerSightRange=600
	OutFightTime=4
	AttSightRange=20
}