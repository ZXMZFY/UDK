/*��Ϸ��ӵ�й����Ե�����Ļ���*/
class AAUDKAweGame_Aggressive extends Actor;

//�ٴδ����˺���ʱ��
var() float InvulnerableTime;

//�Ӵ�֮��ı����ʵı��������������
var() float MoveVelocityMultiple;


//���������Ѿ���ɹ��˺�������
var array<Actor> LateDamageActor;

//�ı�Ӵ�֮��Ӧ(�ص�֮���)
function SetActorVelocity(Actor TakeDamageActor,out Vector out_momentum)
{

}

//�ж��Ƿ��������˺� (��ʱ����ֻ�����һ���˺�)
function bool IsCanTakeDamageAgain(Actor HitActor)
{
    local int i;
    //����Ƿ�����Ѿ���ɹ��˺�
    for(i = 0 ; i < LateDamageActor.length ; i ++)
    {
        if(LateDamageActor[i] == HitActor)
            return false;
    }
    LateDamageActor[LateDamageActor.length] = HitActor;
    SetTimer(InvulnerableTime,false,'EndAcotrInvulnerable');
    return true;
}

//���������˺���Actorȡ�����Ա��ٴδ����˺�
function EndAcotrInvulnerable()
{
    LateDamageActor.Remove(0, 1);
}

defaultproperties
{
    InvulnerableTime=0
    MoveVelocityMultiple=0
}