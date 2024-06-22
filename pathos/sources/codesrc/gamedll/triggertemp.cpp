#include "includes.h"
#include "gd_includes.h"
#include "triggertemp.h"
#include "player.h"

// Link the entity to its class
LINK_ENTITY_TO_CLASS(trigger_temp, CTriggerTemp);

//=============================================
// @brief
//
//=============================================
CTriggerTemp::CTriggerTemp(edict_t* pedict) :
    CTriggerEntity(pedict)
{
    pclient = pedict;
}

//=============================================
// @brief
//
//=============================================
CTriggerTemp::~CTriggerTemp(void)
{
}

//=============================================
// @brief
//
//=============================================
void CTriggerTemp::DeclareSaveFields(void)
{
    CTriggerEntity::DeclareSaveFields();

    DeclareSaveField(DEFINE_DATA_FIELD(CTriggerTemp, m_temp, EFIELD_INT32));
}

//=============================================
// @brief
//
//=============================================
bool CTriggerTemp::KeyValue(const keyvalue_t& kv)
{
    if (!qstrcmp(kv.keyname, "temp"))
    {
        m_temp = SDL_atoi(kv.value);
        return true;
    }
    else
        return CTriggerEntity::KeyValue(kv);
}

//=============================================
// @brief
//
//=============================================
bool CTriggerTemp::Spawn(void)
{
    if (!CTriggerEntity::Spawn())
        return false;

    // Set touch function
    SetTouch(&CTriggerTemp::TriggerTouch);
    return true;
}

//=============================================
// @brief
//
//=============================================
void CTriggerTemp::TriggerTouch(CBaseEntity* pOther)
{
    CPlayerEntity* pPlayer = reinterpret_cast<CPlayerEntity*>(CBaseEntity::GetClass(pclient));
    if (pPlayer) {
        pPlayer->SetTemp(m_temp);
    }
}
