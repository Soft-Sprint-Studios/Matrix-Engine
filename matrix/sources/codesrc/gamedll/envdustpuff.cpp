#include "includes.h"
#include "gd_includes.h"
#include "envdustpuff.h"

// Default delay value
const Float CEnvDustPuff::DEFAULT_DELAY_TIME = 1.5;

// Link the entity to it's class
LINK_ENTITY_TO_CLASS(env_dustpuff, CEnvDustPuff);

//=============================================
// @brief
//
//=============================================
CEnvDustPuff::CEnvDustPuff(edict_t* pedict) :
	CPointEntity(pedict),
	m_isActive(false),
	m_delay(0)
{
}

//=============================================
// @brief
//
//=============================================
CEnvDustPuff::~CEnvDustPuff(void)
{
}

//=============================================
// @brief
//
//=============================================
void CEnvDustPuff::DeclareSaveFields(void)
{
	// Call base class to do it first
	CPointEntity::DeclareSaveFields();

	DeclareSaveField(DEFINE_DATA_FIELD(CEnvDustPuff, m_isActive, EFIELD_BOOLEAN));
	DeclareSaveField(DEFINE_DATA_FIELD(CEnvDustPuff, m_delay, EFIELD_FLOAT));
}

//=============================================
// @brief
//
//=============================================
bool CEnvDustPuff::KeyValue(const keyvalue_t& kv)
{
	if (!qstrcmp(kv.keyname, "MaxDelay"))
	{
		m_delay = SDL_atof(kv.value);
		return true;
	}
	else
		return CPointEntity::KeyValue(kv);
}

//=============================================
// @brief
//
//=============================================
void CEnvDustPuff::Precache(void)
{
}

//=============================================
// @brief
//
//=============================================
bool CEnvDustPuff::Spawn(void)
{
	if (!CPointEntity::Spawn())
		return false;

	if (!HasSpawnFlag(FL_TOGGLE) || HasSpawnFlag(FL_START_ON))
		m_isActive = true;

	if (m_isActive)
	{
		SetThink(&CEnvDustPuff::DustPuffThink);
		m_pState->nextthink = g_pGameVars->time + 0.1 + Common::RandomFloat(0, 1.5);
	}

	if (m_delay <= 0)
		m_delay = DEFAULT_DELAY_TIME;

	return true;
}

//=============================================
// @brief
//
//=============================================
void CEnvDustPuff::DustPuffThink(void)
{
	// Spawn dustpuff effect
	Util::CreateDustPuff(m_pState->origin);

	m_pState->nextthink = g_pGameVars->time + Common::RandomFloat(0, m_delay);
}

//=============================================
// @brief
//
//=============================================
void CEnvDustPuff::CallUse(CBaseEntity* pActivator, CBaseEntity* pCaller, usemode_t useMode, Float value)
{
	bool prevstate = m_isActive;
	switch (useMode)
	{
	case USE_OFF:
		m_isActive = false;
		break;
	case USE_ON:
		m_isActive = true;
		break;
	case USE_TOGGLE:
	default:
		m_isActive = !m_isActive;
		break;
	}

	if (prevstate == m_isActive)
		return;

	if (!m_isActive)
	{
		ClearThinkFunctions();
	}
	else
	{
		SetThink(&CEnvDustPuff::DustPuffThink);
		m_pState->nextthink = g_pGameVars->time + (0.1 + Common::RandomFloat(0, m_delay));
	}
}