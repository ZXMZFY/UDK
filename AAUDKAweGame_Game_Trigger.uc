class AAUDKAweGame_Game_Trigger extends Trigger;

/* ��Ҫ����Ϸ���̿��ƴ����� */

//�¼����
var() int matching;

//�¼���ע
var() string aaaa;

//�¼���������
var() int Count;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    if(Count > 0 && Pawn(Other) != none)
    {
        super.Touch(Other,OtherComp,HitLocation,HitNormal);

		AAUDKAweGame_Game(WorldInfo.Game).Broadcast(self,aaaa);
/*
        `log("Touch the " @ self);

        AAUDKAweGame_Game(WorldInfo.Game).StartSpawn(matching);

       

		switch(matching)
		{
		case 1:
			AAUDKAweGame_Game(WorldInfo.Game).StartSpawn(1);
			break;

		}

        if(matching == 1)
        {
            AAUDKAweGame_Game(WorldInfo.Game).Feature = true;
        }
        if(matching == 1 || matching == 2)
        {
            if(AAUDKAweGame_Game(WorldInfo.Game) != none)
                AAUDKAweGame_Game(WorldInfo.Game).OpenWhichDoor(matching);
        }
    }*/
    }
    Count--;
}

defaultproperties
{
    Count=1
}