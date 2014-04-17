class AAUDKAweGame_NPCInterface extends AAUDKAweGame_ActorInterface;

struct NPCInformation
{
    var name NPCName;
    var bool bActivate;
};

//��ȡ�Ƿ���NPC����ǰ
//NPCInformation Param,ָ��ĳ��NPC
function bool IsHasNpcFront(Pawn P ,out AAUDKAweGame_Npc out_NPCActor,optional NPCInformation Param)
{
    local Actor NPC;
    NPC = GetFaceActor(P);
    if(AAUDKAweGame_Npc(NPC) != none)
    {
        if(Param.NPCName != '')
        {
            //�ж��Ƿ���ָ��NPC�������ж�NPC�Ƿ񼤻�
            if(Param.NPCName != AAUDKAweGame_Npc(NPC).NPCInfo.NPCName || !AAUDKAweGame_Npc(NPC).NPCInfo.bActivate)
                return false;
        }
        out_NPCActor = AAUDKAweGame_Npc(NPC);
        return true;
    }
    return false;
}

defaultproperties
{

}