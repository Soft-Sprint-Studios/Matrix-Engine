#ifndef ENVDUSTPUFF_H
#define ENVDUSTPUFF_H

#include "pointentity.h"

//=============================================
//
//=============================================
class CEnvDustPuff : public CPointEntity
{
public:
	// Default delay value
	static const Float DEFAULT_DELAY_TIME;

public:
	enum
	{
		FL_TOGGLE = (1 << 5),
		FL_START_ON = (1 << 6)
	};

public:
	explicit CEnvDustPuff(edict_t* pedict);
	virtual ~CEnvDustPuff(void);

public:
	virtual bool Spawn(void) override;
	virtual void Precache(void) override;
	virtual void DeclareSaveFields(void) override;
	virtual bool KeyValue(const keyvalue_t& kv) override;
	virtual void CallUse(CBaseEntity* pActivator, CBaseEntity* pCaller, usemode_t useMode, Float value) override;

public:
	void EXPORTFN DustPuffThink(void);

private:
	bool m_isActive;
	Float m_delay;
};
#endif //ENVDUSTPUFF_H