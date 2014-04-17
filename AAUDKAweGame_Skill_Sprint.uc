class AAUDKAweGame_Skill_Sprint extends AAUDKAweGame_Skill;
/*ͻ������*/
//�ͷż���ǰ���ľ��뷽��
var vector SkillStart,SkillAim,SkillCurrent;
var float Distance , TempDistance , OldGroundSpeed;

//��Controller�е�tick�е���
function bool IsUseSkill()
{
    if(bSkillBreak)
        return false;
}

function UseSkill()
{
    local vector X,Y,Z;
    GetAxes(SkillOwner.Rotation,X,Y,Z);
    //�������
    SkillStart = SkillOwner.Location;
    //�����յ�,Distance��ǰ���ľ���
    SkillAim = SkillOwner.Location + X * Distance;

    TempDistance = Distance;

    GotoState('BeActivate');

    OldGroundSpeed = Pawn(SkillOwner).GroundSpeed;

    Pawn(SkillOwner).GroundSpeed *= 4;

    SkillOwner.Acceleration = vect(0,0,0);

    SetTimer(1, false, 'EndSkill');
}

function EndSkill()
{
    bSkillBreak=true;
}

auto state NoActivate
{
    function BeginState(Name PreviousStateName)
    {

    }

    function EndState(Name PreviousStateName)
    {

    }
}

state BeActivate
{
    function BeginState(Name PreviousStateName)
    {
        `log("sprint BeActivate ");
        bSkillBreak=false;
		`log(PlayerController(SkillOwner.Owner).IsKeyboardAvailable() @ "dfhkjsdhfsjk");
		PlayerController(SkillOwner.Owner).SetControllerTiltActive(false);
    } 

    function Tick(float DeltaTime)
    {
        local vector X,Y,Z;
        if(Pawn(SkillOwner) == none  || bSkillBreak )//|| SkillOwner.Physics != PHYS_Walking)
        {
            bSkillBreak=true;
            GotoState('NoActivate');
            return;
        }
        GetAxes(SkillOwner.Rotation, X, Y, Z);

        SkillOwner.velocity = (SkillAim - SkillStart) + X *700;

        if( Distance <= (VSize(SkillOwner.Location - SkillStart)))
        {
            GotoState('NoActivate');
            return;
        }
    }

    function EndState(Name PreviousStateName)
    {
        `log("sprint end");
        bSkillBreak=false;
        Controller(SkillOwner.owner).GotoState('PlayerWalking');
        Pawn(SkillOwner).GroundSpeed = OldGroundSpeed;
    }
}

defaultproperties
{
    bSkillBreak=false
    Distance=500.0
}