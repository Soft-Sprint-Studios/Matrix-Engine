/*
===============================================
Pathos Engine - Created by Andrew Stephen "Overfloater" Lucas

Copyright 2016
All Rights Reserved.
===============================================
*/

#include "includes.h"
#include "gd_includes.h"
#include "funcwall.h"

// Link the entity to it's class
LINK_ENTITY_TO_CLASS(func_wall, CFuncWall);

//=============================================
// @brief
//
//=============================================
CFuncWall::CFuncWall( edict_t* pedict ):
	CBaseEntity(pedict)
{
}

//=============================================
// @brief
//
//=============================================
CFuncWall::~CFuncWall( void )
{
}

//=============================================
// @brief
//
//=============================================
bool CFuncWall::Spawn( void )
{
	if(!HasSpawnFlag(FL_TAKE_ANGLES))
		m_pState->angles = ZERO_VECTOR;

	m_pState->movetype = MOVETYPE_PUSH;
	m_pState->solid = SOLID_BSP;
	m_pState->effects |= EF_STATICENTITY;

	if(m_pState->rendermode == RENDER_NORMAL
		|| (m_pState->rendermode & 255) == RENDER_TRANSALPHA)
		m_pState->flags |= FL_WORLDBRUSH;

	if(m_pState->renderamt == 0 && (m_pState->rendermode & 255) == RENDER_TRANSCOLOR)
	{
		m_pState->rendermode = RENDER_NORMAL;
		m_pState->effects |= EF_COLLISION;
	}

	if(!SetModel(m_pFields->modelname))
		return false;

	return true;
}

//=============================================
// @brief
//
//=============================================
void CFuncWall::CallUse( CBaseEntity* pActivator, CBaseEntity* pCaller, usemode_t useMode, Float value )
{
	switch(useMode)
	{
	case USE_OFF:
		m_pState->frame = 0;
		break;
	case USE_ON:
		m_pState->frame = 1;
		break;
	case USE_TOGGLE:
	default:
		if(m_pState->frame)
			m_pState->frame = 0;
		else
			m_pState->frame = 1;
		break;
	}
}