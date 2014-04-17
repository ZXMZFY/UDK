//������ƹ����������ˢ���Լ�����״̬
//���Լ̳и��࣬�Թ��������¼����б༭���⴦��
class AAUDKAweGame_MonstersQueue extends Actor;

struct MonsterInfoArray
{
    //�ýṹ����MonsterBase��
    var array<MonsterInfo_A> MonsterInfo;
    var int Num;
    var int Match;
    var bool bHaveSpawned;
};

//����ӵ�еĹ���������
var array<AAUDKAweGame_MonsterSpawner>  OccupyEnemySpawners;

//����ʵ�ʴ��ڵ�����
var array<MonsterInfoArray> MonsterArray;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}


function GetOccupyEnemySpawners()
{
    local AAUDKAweGame_MonsterSpawner AMS;

    foreach DynamicActors(class'AAUDKAweGame_MonsterSpawner', AMS)
    {
        //����������
        OccupyEnemySpawners[OccupyEnemySpawners.length] = AMS;
        `log("AMS" @ AMS);
        //�������������
        AMS.MonstersQueue = self;
    }
}

function bool IsHaveOccupyEnemySpawners()
{
    if(OccupyEnemySpawners.length <= 0)
        return false;
    return true;
}

function ClearQueue()
{
	OccupyEnemySpawners.length = 0;
}

//��ʼ��������
//������Match �ڼ������ 
function StartSpawn(int Match)
{
    local int i;
    for(i = 0 ; i < OccupyEnemySpawners.length ; i ++)
    {
        `log("OccupyEnemySpawners[i]" @ OccupyEnemySpawners[i]);
        if(OccupyEnemySpawners[i].Match == Match)
        {
            OccupyEnemySpawners[i].SpawnEnemy();
        }
    }
}
/*
function AwesomeMonstersQueue SetQueueOccupy(AwesomeMonsterSpawner Spawner)
{
    local int i;
    for(i = 0 ; i < OccupyEnemySpawners.length ; i++)
    {
        if(OccupyEnemySpawners[i] == Spawner)
            return none;
    }
    //����������������������������
    OccupyEnemySpawners[OccupyEnemySpawners.length] = Spawner;
    return self;
}*/


//����һ������
function AddOneMonster(int Match,MonsterInfo_A MInfo)
{
    local bool bIsNewMatchMonster;
    local MonsterInfoArray TempMonsterInfoArray;
    local int i;

    //`log("Add a Monster! this team" @ Match);
    bIsNewMatchMonster = true;
    if(MInfo.MonsterName == '')
    {
        `log("The monster have not a name");
        return;
    }


    //������Ĺ���
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        if(Match == MonsterArray[i].Match)
        {
            //�����е���Ĺ����ֵ���棬����Ĺ�����+1
            MonsterArray[i].MonsterInfo[MonsterArray[i].MonsterInfo.length] = MInfo;
            MonsterArray[i].Num++;
            bIsNewMatchMonster = false;
        }
    }

	//����Ϊ�µ�һ�飬�����Ǽ��뵽ԭ������
    if(bIsNewMatchMonster)
    {
        //��û�е���Ĺ����ֵ����
        TempMonsterInfoArray.MonsterInfo[TempMonsterInfoArray.MonsterInfo.length] = MInfo;
        TempMonsterInfoArray.Match = Match;
        TempMonsterInfoArray.Num = 1;
        MonsterArray[MonsterArray.length] = TempMonsterInfoArray;
        i = MonsterArray.length -1;
    }
    
    //����¼�
    CheckEvent("add",i,Match,MInfo);

    //MonsterArray[MonsterArray.length].MonsterInfo[MonsterArray[MonsterArray.length].MonsterInfo.length] = MInfo;
    //MonsterArray[MonsterArray.length].Match = Match;
    //MonsterArray[MonsterArray.length].Num = 1;
    /*
    //test
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        `log("Match & Num" @ MonsterArray[i].Match @ MonsterArray[i].Num);
        for(x = 0 ; x < MonsterArray[i].MonsterInfo.length ; x ++)
        {
            `log(MonsterArray[i].MonsterInfo[x].MonsterName);
            `log(MonsterArray[i].MonsterInfo[x].Match);
        }
    }*/
}

//����һ������
function bool MinusOneMonster(int Match,MonsterInfo_A MInfo)
{
    local int i;
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        if(Match == MonsterArray[i].Match)
        {
            //����¼�
            CheckEvent("sub",i,Match,MInfo);
            MonsterArray[i].Num--;
            if(MonsterArray[i].Num < 0)
                return false;
            return true;
        }
    }
    return false;
}

//�����Ϸ��(gameinfo)������(����)�¼�����
//���磬���ţ�ˢ������
/* EventCode ��������ʱ�仹�Ǽ����¼�
 * WhichIndexMonster ����������һ��
 * Match ƥ����¼�
 * MInfo ��������
 */
function CheckEvent(string EventCode,optional int WhichIndexMonster,optional int Match,optional MonsterInfo_A MInfo)
{
    //��Ϸ��������
    if(EventCode == "sub")
    {//numΪ��1֮��
		//��˼Ϊ��WhichIndexMonster��Ĺ������һ����������ʱ������Match�¼�
        if(MonsterArray[WhichIndexMonster].Num - 1 == 0)
        {
			`log("AAUDKAweGame_Game(WorldInfo.Game).DiedAllMonster(Match);");
			AAUDKAweGame_Game(WorldInfo.Game).DiedAllMonster(Match);
        }
    }
/*
    if(EventCode == "add")
    {//numΪ+1֮��
        `log("wwwwaaaaaa" @ WhichIndexMonster);
        `log("wwwwaaaaaa" @ MonsterArray.length);
        if(MonsterArray[WhichIndexMonster].Num == 1 && Match == 1 && MonsterArray[WhichIndexMonster].bHaveSpawned == false)
        {
            MonsterArray[WhichIndexMonster].bHaveSpawned = true;
            if(AwesomeGameBase(WorldInfo.Game) != none)
                AwesomeGameBase(WorldInfo.Game).OpenWhichDoor(Match);
        }
    }*/
}

defaultproperties
{

}

