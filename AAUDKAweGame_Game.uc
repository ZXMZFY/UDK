class AAUDKAweGame_Game extends  UTGame;

var int NextWaveTime;

var int SpawnersMatching[10];

//������Ӧ�ñ���(���ֵ����kismet��)
var int IndexDoorJustBeOpen;

var int CurMonsterMatch;

//�������
var AAUDKAweGame_MonstersQueue MonstersQueue;

//Ϊtrueʱ������playerController�ľ�ͷ��д���Ե�������һ�����
var bool Feature;

var AAUDKAweGame_PlayerController MyPC;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
	//`log("11111111111111111111111111111111");
    MonstersQueue = spawn(class'AAUDKAweGame_MonstersQueue',self,, Location);
}

/************ ���̿��� ************/
function RestartPlayer(Controller aPlayer)
{
	 if(PlayerController(aPlayer) != none)
    {
        //��ʾ��Ļ��Ļ
        SetTimer(0,false,'ShowDialog');
    }
    super.RestartPlayer(aPlayer);
}

function InitMonstersQueue()
{
	if(MonstersQueue.IsHaveOccupyEnemySpawners() == false)
	{
        MonstersQueue.GetOccupyEnemySpawners();
    }
	else
	{
		MonstersQueue.ClearQueue();
		MonstersQueue.GetOccupyEnemySpawners();
	}
}

function Actor GetMonstersQueue()
{
    return MonstersQueue;
}

//��ʾ��Ļ��Ļ
function ShowDialog()
{
    Broadcast(self,"welcome to the game,start spawn monster");
}

//��ʼˢ��
function StartSpawn(int matching)
{
    //local int i;
    MonstersQueue.StartSpawn(matching);
}

function int GetOpenDoorIndex()
{
    return IndexDoorJustBeOpen;
}

function DiedAllMonster(int matching)
{
	CurMonsterMatch = matching;
	TriggerGlobalEventClass(class'AAUDKAweGame_Game_SeqEvent_DiedAllMonster', self);

}

function OpenWhichDoor(int matching)
{
    //SpawnersMatching[matching]--;
    //`log("SpawnersMatching num === " @ SpawnersMatching[matching]);
    //if(SpawnersMatching[matching] == 0)
    //{
        IndexDoorJustBeOpen = matching;

        `log("OpenDoor");
        //�����ŵ��¼�
        TriggerGlobalEventClass(class'AAUDKAweGame_Game_SeqEvent_OpenDoor', self);

    //}
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	MyPC = AAUDKAweGame_PlayerController(super.Login(Portal,Options,UniqueID,ErrorMessage));	
	return MyPC;
}

/***************** ״̬���� ******************/

state MatchInProgress
{

}

defaultproperties
{
    PlayerControllerClass=class'AAUDKAweGame_Game.AAUDKAweGame_PlayerController'
    bScoreDeaths=false
    DefaultInventory(0)=None
    DefaultPawnClass=class'AAUDKAweGame_Game.AAUDKAweGame_Pawn'

    NextWaveTime=2
    
    Feature = false
}