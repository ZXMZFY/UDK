class AAUDKAweGame_Buff extends Actor;



enum BHitType
{
    HT_physics,
    HT_Magic,
};

    //����
    var name BuffName;
    //�˺�����
    var BHitType HitType;
    //ÿ��ÿ���˺�
    var float Damage;
    //֧��������
    var int MaxLevel;
    //��ǰ����
    var int NowLevel;
    //��������
    var float BuffTime;
    //��ǰʱ��
    var float NowTime;
    //��һ�δ�����ʱ��(һ��Ϊ������ʱ��+���)
    var float NextTime;
    //���
    var float Interval;
    //����ǿ��
    var int BuffRank;

//�����ĸ�BUFF��
var AAUDKAweGame_BuffSocket BuffSocket;

//����˭
var Pawn BuffOwner;

//˭�ų���
var Pawn BuffSender;

var AAUDKAweGame_Properties SenderPro;
var AAUDKAweGame_Properties SelfPro;



function BuffInit(Pawn Sender,Pawn tBuffOwner,AAUDKAweGame_BuffSocket Socket)
{
	BuffSender = Sender;
    BuffOwner = tBuffOwner;
	BuffSocket = Socket;

	if(AAUDKAweGame_Pawn(BuffSocket.OwnerPawn) != none)
		SelfPro = AAUDKAweGame_Pawn(BuffSocket.OwnerPawn).m_Pro;
	if(AAUDKAweGame_Monster(BuffSocket.OwnerPawn) != none)
		SelfPro = AAUDKAweGame_Monster(BuffSocket.OwnerPawn).m_MonsterProperties;

	if(AAUDKAweGame_Pawn(BuffSender) != none)
		SenderPro = AAUDKAweGame_Pawn(BuffSender).m_Pro;
	if(AAUDKAweGame_Monster(BuffSender) != none)
		SenderPro = AAUDKAweGame_Monster(BuffSender).m_MonsterProperties;		
}

function RefreshBuff()
{

}


defaultproperties
{

}