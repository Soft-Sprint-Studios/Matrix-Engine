#ifndef TRIGGERONCE_H
#define TRIGGERONCE_H

#include "triggerentity.h"

// Forward declaration of edict_t (assuming it's not already included in triggerentity.h)
struct edict_t;

//=============================================
//
//=============================================
class CTriggerTemp : public CTriggerEntity
{
public:
    explicit CTriggerTemp(edict_t* pedict);
    virtual ~CTriggerTemp(void);

public:
    virtual bool Spawn(void) override;
    virtual void DeclareSaveFields(void) override;
    virtual bool KeyValue(const keyvalue_t& kv) override;

public:
    void EXPORTFN TriggerTouch(CBaseEntity* pOther);

private:
    edict_t* pclient; // Declare pclient as a private member variable
    float m_temp;     // Assuming m_temp is of type float as per convention
};

#endif // TRIGGERONCE_H