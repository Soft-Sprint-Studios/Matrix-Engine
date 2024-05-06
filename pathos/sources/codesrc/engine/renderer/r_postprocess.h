/*
===============================================
Pathos Engine - Created by Andrew Stephen "Overfloater" Lucas

Copyright 2016
All Rights Reserved.
===============================================
*/

#ifndef POSTPROCESS_H
#define POSTPROCESS_H

#include "screenfade.h"
#include "r_rttcache.h"

enum pp_shadertypes_t
{
	SHADER_GAMMA = 0,
	SHADER_BLUR_H,
	SHADER_BLUR_V,
	SHADER_DISTORT,
	SHADER_MBLUR,
	SHADER_ENVFADE,
	SHADER_GRAIN,
	SHADER_NORMAL,
	SHADER_CHROMATIC,
	SHADER_FXAA,
	SHADER_BW,
	SHADER_BLEACH,
	SHADER_BLOOM,
	SHADER_VIGNETTE,
	SHADER_SSAO,
};

struct pp_shader_attribs
{
	pp_shader_attribs():
		u_modelview(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_projection(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_offset(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_color(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_gamma(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_screenwidth(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_screenheight(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_timer(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_texture1(CGLSLShader::PROPERTY_UNAVAILABLE),
		u_texture2(CGLSLShader::PROPERTY_UNAVAILABLE),
		a_origin(CGLSLShader::PROPERTY_UNAVAILABLE),
		a_texcoord(CGLSLShader::PROPERTY_UNAVAILABLE),
		d_type(CGLSLShader::PROPERTY_UNAVAILABLE)
		{}

	Int32	u_modelview;
	Int32	u_projection;

	Int32	u_offset;
	Int32	u_color;
	Int32	u_gamma;

	Int32	u_screenwidth;
	Int32	u_screenheight;
	Int32	u_timer;
	Int32	u_chromaticStrength;
	Int32	u_FXAAStrength;
	Int32	u_BWStrength;
	Int32	u_BleachStrength;
	Int32	u_BloomStrength;
	Int32	u_VignetteStrength;
	Int32	u_VignetteRadius;
	Int32	u_SSAOStrength;
	Int32	u_SSAORadius;

	Int32	u_texture1;
	Int32	u_texture2;

	Int32	a_origin;
	Int32	a_texcoord;

	Int32 d_type;
};

/*
====================
CPostProcess

====================
*/
class CPostProcess
{
public:
	CPostProcess( void );
	~CPostProcess( void );

public:
	// Initializes the class
	bool Init( void );
	// Shuts down the class
	void Shutdown( void );

	// Initializes OpenGL objects
	bool InitGL( void );
	// Clears OpenGL objects
	void ClearGL( void );
	// Initializes game objects
	bool InitGame( void );
	// Clears game objects
	void ClearGame( void );

	// Draws postprocess effects
	bool Draw( void );

private:
	// Draws gamma correction
	bool DrawGamma( void );
	// Draws gaussian blur
	bool DrawBlur( void );
	// Draws distortion effect
	bool DrawDistortion( void );
	// Draws motion blur
	bool DrawMotionBlur( void );
	// Draws fade effects
	bool DrawFade( screenfade_t& fade );
	// Draws screen film grain
	bool DrawFilmGrain( void );
	// Draws screen chromatic
	bool DrawChromatic(void);
	// Draws screen FXAA
	bool DrawFXAA(void);
	// Draws screen BW
	bool DrawBW(void);
	// Draws screen Bleach bypass
	bool DrawBleachBypass(void);
	// Draws screen Bloom
	bool DrawBloom(void);
	// Draws screen Vignette
	bool DrawVignette(void);
	// Draws SSAO
	bool DrawSSAO(void);

	// Fetches screen contents
	static void FetchScreen( rtt_texture_t** ptarget );
	// Creates motion blur texture
	void ClearMotionBlur( void );
	// Creates the screen texture
	void CreateScreenTexture( void );

public:
	// Toggle motion blur effect message
	void SetMotionBlur( bool active, Float blurfade, bool override );
	// Reads fade message
	void SetFade( Uint32 layerindex, Float duration, Float holdtime, Int32 flags, const color24_t& color, byte alpha, Float timeoffset );
	// Sets gaussian blur
	void SetGaussianBlur( bool active, Float alpha );

private:
	// Gamma cvar
	CCVar*			m_pCvarGamma;
	// Blur FBO binding
	fbobind_t		m_blurFBO;

	// TRUE if gaussian blur is active
	bool			m_gaussianBlurActive;
	// TRUE if motion blur is active
	bool			m_motionBlurActive;
	// TRUe if need to override motion blur
	bool			m_blurOverride;
	
	// True if first game of motion blur
	bool			m_isFirstFrame;
	// Motion blur fade amount
	Float			m_blurFade;

	// Last time we were in water
	Float			m_lastWaterTime;
	// Gaussian blur alpha
	Float			m_gaussianBlurAlpha;

private:
	// Screenfade information
	screenfade_t	m_fadeLayersArray[MAX_FADE_LAYERS];

private:
	// Pointer to shader object
	class CGLSLShader*	m_pShader;
	// Pointer to VBO object
	class CVBO*			m_pVBO;

	// Filmgrain cvar
	CCVar*			m_pCvarFilmGrain;
	// Chromatic cvar
	CCVar* m_pCvarChromatic;
	// Chromatic strength cvar
	CCVar* m_pCvarChromaticStrength;
	// FXAA cvar
	CCVar* m_pCvarFXAA;
	// FXAA strength cvar
	CCVar* m_pCvarFXAAStrength;
	// BW cvar
	CCVar* m_pCvarBW;
	// BW strength cvar
	CCVar* m_pCvarBWStrength;
	// Bleach bypass cvar
	CCVar* m_pCvarBleachbypass;
	// Bleach bypass strength cvar
	CCVar* m_pCvarBleachbypassStrength;
	// Bloom cvar
	CCVar* m_pCvarBloom;
	// Bloom strength cvar
	CCVar* m_pCvarBloomStrength;
	// Vignette cvar
	CCVar* m_pCvarVignette;
	// Vignette strength cvar
	CCVar* m_pCvarVignetteStrength;
	// Vignette Radius cvar
	CCVar* m_pCvarVignetteRadius;
	// SSAO cvar
	CCVar* m_pCvarSSAO;
	// SSAO strength cvar
	CCVar* m_pCvarSSAOStrength;
	// SSAO Radius cvar
	CCVar* m_pCvarSSAORadius;
	// Postporcess cvar
	CCVar*			m_pCvarPostProcess;

	// Screen RTT
	rtt_texture_t*	m_pScreenRTT;
	
	// Screen texture pointer
	en_texalloc_t*	m_pScreenTexture;
	// Shader attributes
	pp_shader_attribs m_attribs;
};

extern CPostProcess gPostProcess;
#endif