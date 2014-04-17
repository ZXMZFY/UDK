Class AAUDKAweGame_Properties extends Object;

enum DamageBreakRes
{
	Res_A,
	Res_B,
	Res_C,
	Res_D
};

enum DamageFallRes
{
	Res_A,
	Res_B,
	Res_C,
	Res_D
};


var(res) int m_DamageBreakHit[4];
var(res) int m_DamageFallHit[4];
//Ӳֱ������
var(res) float m_ReduceCriP;
//���ɼ���
var(res) float m_ReduceFallP;
//��ϼ���
var(res) float m_ReduceBreakP;

var(PawnName) AAUDKAweGame_Monster OwnerPawn;
var(PawnName) name MonsterPropertiesName;

var(ability) int m_MaxHP;
var(ability) int m_ATK;
var(ability) int m_MAGIC;
var(ability) int m_DEF;
var(ability) int m_MAC;
var(ability) float m_Special;
var(ability) int m_Lv;
var(ability) DamageBreakRes m_DamageBreakRes;
var(ability) DamageFallRes m_DamageFallRes;


var int CurHP;

//�ٶ���
var(speed) float MaxRunSpeed;
//MaxRunSpeed * SpeedRate
var float CurRunSpeed;
var float SpeedRate;

//�����ٶ�Ĭ��Ϊ1
var(speed) float AtkSpeed;
var float AtkRate;

function InitForPawn()
{
	UpdataRunSpeed();
	UpdataAtkSpeed();
	OwnerPawn.HealthMax = m_MaxHP;
}

//�����ٶ�(ÿ�θ�������ʱ������ִ��)
function UpdataRunSpeed()
{
	CurRunSpeed = MaxRunSpeed * SpeedRate;
	OwnerPawn.GroundSpeed = CurRunSpeed;
}

//��������
function AddRunSpeedRate(float AddOrSub)
{
	SpeedRate = SpeedRate + AddOrSub;
	UpdataRunSpeed();
}

function float UpdataAtkSpeed()
{
	AtkSpeed = AtkSpeed * AtkRate;
	return AtkSpeed;
}

defaultproperties
{

}