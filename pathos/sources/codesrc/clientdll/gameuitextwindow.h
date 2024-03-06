/*
===============================================
Pathos Engine - Created by Andrew Stephen "Overfloater" Lucas

Copyright 2016
All Rights Reserved.
===============================================
*/

#ifndef GAMEUITEXTWINDOW_H
#define GAMEUITEXTWINDOW_H

#include "gameuielements.h"

/*
====================
CGameUITextWindow

====================
*/
class CGameUITextWindow : public CGameUIWindow
{
public:
	// Text inset for the text tab
	static const Uint32 TEXTWINDOW_TEXT_TAB_TEXT_INSET;
	// Title text default font set name
	static const Char TEXTWINDOW_TITLE_DEFAULT_FONT_SET_NAME[];
	// Title text default font size
	static const Uint32 TEXTWINDOW_TITLE_DEFAULT_FONT_SIZE;
	// Title text default font size
	static const Uint32 TEXTWINDOW_TITLE_LOWRES_FONT_SIZE;
	// Display text lowres font size
	static const Uint32 TEXTWINDOW_LOWRES_FONT_SIZE;

public:
	explicit CGameUITextWindow( Int32 flags, Int32 originX, Int32 originY, Uint32 width, Uint32 height );
	~CGameUITextWindow();

public:
	// Initializes the window
	void init( void ) override;
	// Initializes the data
	bool initData( const Char* pstrtextfilepath, const Char* pstrPassCode );
	// Returns the current window information
	void getInformation( CString& textfilepath, CString& passcode ) const;
	// Returns the type of the window
	virtual gameui_windows_t getWindowType( void ) const override { return GAMEUI_TEXTWINDOW; }

public:
	// Closes the window
	void CloseWindow( void );

private:
	// Title text object
	CGameUIText* m_pTitleText;
	// Text tab object
	CGameUITextTab* m_pTextTab;

	// Text file path
	CString m_textFilePath;
	// Passcode if any
	CString m_passcode;
};

/*
=================================
CGameUITextWindowExitCallbackEvent

=================================
*/
class CGameUITextWindowExitCallbackEvent : public CGameUICallbackEvent
{
public:
	explicit CGameUITextWindowExitCallbackEvent( CGameUITextWindow* pTextWindow ):
		m_pTextWindow(pTextWindow)
	{ 
	};
	virtual ~CGameUITextWindowExitCallbackEvent( void ) { };

public:
	// Performs the action
	virtual void PerformAction( Int32 param ) override;
	// Handles a special key event
	virtual bool KeyEvent( Int32 button, Int16 mod, bool keyDown ) override { return false; }
	// Handles a mouse button event
	virtual bool MouseButtonEvent( Int32 mouseX, Int32 mouseY, Int32 button, bool keyDown ) override { return false; }

private:
	// Text window object
	CGameUITextWindow* m_pTextWindow;
};

#endif //GAMEUITEXTWINDOW_H