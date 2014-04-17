class AAUDKAweGame_MonsterSpawner extends Actor
    placeable;

//�����Ĺ���
var AAUDKAweGame_Monster MySpawnedEnemy;

//������п�����
var AAUDKAweGame_MonstersQueue MonstersQueue;


//���������ĸ���
var() int Match;

var() class<AAUDKAweGame_Monster> AwesomeMonsterBaseClass;

//�����ԭ��
var() const archetype AAUDKAweGame_Monster AwesomeMonsterArchetype;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}

//����һ������
function SpawnEnemy()
{
	local rotator aa;
    //�������Ϊ��
    if(MySpawnedEnemy == none)
    {
		//���һ������
		aa.Yaw = Rand(32768);
		SetRotation(aa);
        //����һ������
		if(AwesomeMonsterArchetype != none)
		{
			MySpawnedEnemy = spawn(AwesomeMonsterArchetype.Class,,, Location);
		}
		else
		{
			MySpawnedEnemy = spawn(AwesomeMonsterBaseClass,,, Location);
		}

        //���ùֹ���Ķ���
        MySpawnedEnemy.MonsterInfo.Match = Match;


        //���ù���Ĳ�����
        MySpawnedEnemy.SetMyMonsterSpawner(self);

        //���ÿ�������������+1
        MonstersQueue.AddOneMonster(MySpawnedEnemy.MonsterInfo.Match,MySpawnedEnemy.MonsterInfo);
    }
    else
        `log("MySpawnedEnemy" @ MySpawnedEnemy);
}



function EnemyDied()
{

    //����Ϸ�����෢���ǵڼ���ּ���
    MonstersQueue.MinusOneMonster(MySpawnedEnemy.MonsterInfo.Match,MySpawnedEnemy.MonsterInfo);
    
    MySpawnedEnemy = none;
  //  SpawnEnemy();
}

function AAUDKAweGame_Monster SpawnBoss()
{
    //local AwesomeBoss TheBoss;
    //TheBoss = spawn(class'AwesomeBoss', self,, Location);
    //return TheBoss;
}

function MakeEnemyRunAway()
{
    //if(MySpawnedEnemy != none)
        //MySpawnedEnemy.RunAway();
}

function bool CanSpawnEnemy()
{
    return MySpawnedEnemy == none;
}

defaultproperties
{
    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
    End Object
    Components.Add(Sprite)
    
    bHidden=false
    
    AwesomeMonsterBaseClass=class'AAUDKAweGame_Monster';
    
}