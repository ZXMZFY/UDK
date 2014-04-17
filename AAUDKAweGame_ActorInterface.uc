class AAUDKAweGame_ActorInterface extends Actor;


//��ȡpawn�����Actor
function Actor GetFaceActor(Pawn P , optional float TraceLen)
{
    local Vector X,Y,Z,HitLocation,StartLocation, HitNormal ,EndLocation;
    local Actor AimActor;
    GetAxes(P.Rotation,X,Y,Z);
    if(TraceLen == 0)
        EndLocation = P.Location +(X * 200);
    else
        EndLocation = P.Location +(X * TraceLen);
    StartLocation = P.Location;
    //�����ǰ��Ĭ��ǰ��200�ķ�Χ�ڵ�Actor��
    AimActor = Trace(HitLocation,HitNormal,StartLocation,EndLocation,true);
    if(AimActor != P)
        return AimActor;
    else
        return none;
}

//��������Actor������
function SwapLocation(Actor A,Actor B)
{
    local Vector x;
    x = A.Location;
    A.SetLocation(B.Location);
    B.SetLocation(x);
}


//��ProcessMove��������Ϸ���ж�������ݼ��̷�����ʱ���ùܣ�
//(������дPlayerController��GetPlayerViewPoint�����ſ�ʹ�ã�out_Location = Pawn.Location + PlayerViewOffset;��)
function SetPlayerForward(PlayerController PC)
{
    if(PC.PlayerInput.aForward != 0.f)
    {
        if( PC.PlayerInput.aForward > 0.f)
        {
            if( PC.PlayerInput.aStrafe > 0.f )
                PC.Pawn.SetRotation(rot(0,8192,0));
            else if(PC.PlayerInput.aStrafe < 0.f)
                PC.Pawn.SetRotation(rot(0,-8192,0));
            else
                PC.Pawn.SetRotation(rot(0,0,0));
        }
        if( PC.PlayerInput.aForward < 0.f )
        {
            if( PC.PlayerInput.aStrafe > 0.f )
                PC.Pawn.SetRotation(rot(0,24576,0));
            else if( PC.PlayerInput.aStrafe < 0.f )
                PC.Pawn.SetRotation(rot(0,-24576,0));
            else
                PC.Pawn.SetRotation(rot(0,32768,0));
        }
    }
    else
    {
        if(PC.PlayerInput.aStrafe > 0.f)
            PC.Pawn.SetRotation(rot(0,16384,0));
        else if(PC.PlayerInput.aStrafe < 0.f)
            PC.Pawn.SetRotation(rot(0,-16384,0));
    }
    PC.SetRotation(PC.Pawn.Rotation);
}


defaultproperties
{

}