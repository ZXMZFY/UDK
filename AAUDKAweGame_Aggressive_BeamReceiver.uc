class AAUDKAweGame_Aggressive_BeamReceiver extends AAUDKAweGame_Aggressive
    placeable;
    
//���߽��յ�Ĳ�۵�name
var name BeamSockets;

//�������ֵ��ƥ����ͬ�ķ�����
var() int  MatchingEmitter;

var float x,y;

var SkeletalMeshComponent Mesh;

auto state noOpen
{
    function BeginState(Name PreviousStateName)
    {
        Moving();
    }
}

function Moving()
{/*
    local vector haha;
    if(x <= 300 && x>= -300)
    {
        x+=y;
        haha.X = 0;
        haha.y = y;
        haha.z = 0;

        SetLocation(Location + haha);
    }
    else
    {
        x = 0;
        y = y * -1;
    }
    SetTimer(1,false,'Moving');*/
}

defaultproperties
{
    Begin Object Class=SkeletalMeshComponent Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'KismetGame_Assets.Pickups.SK_Carrot'
    End Object
    Mesh=FirstPersonMesh
    Components.Add(FirstPersonMesh)
    
    MatchingEmitter=0
    
    y=50
    x=0

	Physics=PHYS_Interpolating
}