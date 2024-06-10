/*
===============================================
Pathos Engine - Created by Andrew Stephen "Overfloater" Lucas

Copyright 2016
All Rights Reserved.

===============================================
*/

#include "includes.h"
#include "system.h"
#include "window.h"
#include "vid.h"
#include "enginestate.h"
#include "config.h"
#include "file.h"
#include "r_main.h"

#include "logfile.h"
#include "commands.h"
#include "input.h"
#include "texturemanager.h"

#include "edict.h"

#include "cl_entity.h"
#include "cl_main.h"
#include "sv_main.h"

#include "brushmodel.h"
#include "modelcache.h"
#include "console.h"
#include "networking.h"
#include "saverestore.h"
#include "tga.h"
#include "r_menu.h"
#include "vid.h"
#include "filewriterthread.h"
#include <iostream>
#include <vector>
#include <sstream>

// Port CVAR
CCVar* g_pCVarPort = nullptr;

//=============================================
// @brief Loads a map and initializes the game
// 
//=============================================
void Cmd_Sys_Quit( void ) 
{ 
	ens.exit = true; 
}

//=============================================
// @brief Loads a map and initializes the game
// 
//=============================================
void Cmd_LoadMap( void )
{
	if(ens.isinprocesstringcommand)
	{
		Con_Printf("This function cannot be called from SV_ProcessStringCommand.\n");
		return;
	}

	if(gCommands.Cmd_Argc() <= 1)
	{
		Con_Printf("map usage: map <mapname>.\n");
		return;
	}

	// Verify that the file exists before resetting
	const Char* pstrFilename = gCommands.Cmd_Argv(1);
	CString filepath;
	filepath << "maps/" << pstrFilename;
	if(!qstrstr(pstrFilename, ".pbsp"))
		filepath << ".pbsp";

	if(!FL_FileExists(filepath.c_str()))
	{
		Con_Printf("Could not load map '%s'.\n", pstrFilename);
		return;
	}

	SV_SpawnGame(pstrFilename);
}


//=============================================
// @brief Shows list of active bsps in the maps folder
// 
//=============================================
void Cmd_ListMaps() {
	const std::string mapDirectory = std::string(DEFAULT_GAMEDIR) + "\\maps\\";
	const std::string filePattern = "*.pbsp";
	std::string searchPath = mapDirectory + filePattern;
	std::vector<std::string> mapList;
	WIN32_FIND_DATA fileData;
	HANDLE hFind = FindFirstFile(searchPath.c_str(), &fileData);
	if (hFind == INVALID_HANDLE_VALUE) {
		Con_Printf("Error: Could not open the maps folder.\n");
		return;
	}
	do {
		std::string fileName = fileData.cFileName;
		std::string mapName = fileName.substr(0, fileName.size() - 4);
		mapList.push_back(mapName);
	} while (FindNextFile(hFind, &fileData) != 0);
	FindClose(hFind);
	if (mapList.empty()) {
		Con_Printf("No maps found in the maps folder.\n");
	}
	else {
		Con_Printf("List of maps in the maps folder:\n");
		for (size_t i = 0; i < mapList.size(); ++i) {
			Con_Printf("- %s\n", mapList[i].c_str());
		}
	}
}

//=============================================
// @brief Pauses the game
// 
//=============================================
void Cmd_Pause( void )
{
	if(svs.pauseovveride)
		return;

	Sys_SetPaused(svs.paused ? false : true, true);
}

//=============================================
// @brief Position of the player in the world
// 
//=============================================
void Cmd_Pos(void)
{
	std::stringstream ss;
	ss << "Current Pos: " << rns.view.v_origin.x << ", " << rns.view.v_origin.y << ", " << rns.view.v_origin.z;
	std::string position_str = ss.str();
	Con_Printf(position_str.c_str());
}


//=============================================
// @brief Saves the game state to a file
// 
//=============================================
void Cmd_Save( void )
{
	if(svs.maxclients > 1)
	{
		Con_Printf("Saving is not allowed in multiplayer.\n");
		return;
	}

	if(ens.gamestate != GAME_RUNNING)
	{
		Con_Printf("Can't save when game is not running.\n");
		return;
	}

	if(svs.phostclient->pedict->state.health <= 0)
	{
		Con_Printf("Can't save with dead player.\n");
		return;
	}

	// Create a game save
	if(gSaveRestore.CreateSaveFile(svs.mapname.c_str(), SAVE_REGULAR, nullptr, nullptr))
	{
		// Show the message
		svs.dllfuncs.pfnShowSaveGameMessage();

		// Skip frame because we could have a major time-buildup
		ens.skipframe = true;
	}
	else
	{
		// Show the message
		svs.dllfuncs.pfnShowSaveGameBlockedMessage();
	}
}

//=============================================
// @brief Saves the game state to a file
// 
//=============================================
void Cmd_QuickSave( void )
{
	if(svs.maxclients > 1)
	{
		Con_Printf("Saving is not allowed in multiplayer.\n");
		return;
	}

	if(ens.gamestate != GAME_RUNNING)
	{
		Con_Printf("Can't save when game is not running.\n");
		return;
	}

	if(svs.phostclient->pedict->state.health <= 0)
	{
		Con_Printf("Can't save with dead player.\n");
		return;
	}

	// Create a game save
	if(gSaveRestore.CreateSaveFile(QUICKSAVE_FILE_NAME, SAVE_QUICK, nullptr, nullptr, (g_pCvarKeepOldSaves->GetValue() >= 1) ? true : false))
	{
		// Show the message
		svs.dllfuncs.pfnShowSaveGameMessage();

		// Skip frame because we could have a major time-buildup
		ens.skipframe = true;
	}
	else
	{
		// Show the message
		svs.dllfuncs.pfnShowSaveGameBlockedMessage();
	}
}

//=============================================
// @brief Saves the game state to a file
// 
//=============================================
void Cmd_AutoSave( void )
{
	if(svs.maxclients > 1)
	{
		Con_Printf("Saving is not allowed in multiplayer.\n");
		return;
	}

	if(ens.gamestate != GAME_RUNNING)
	{
		Con_Printf("Can't save when game is not running.\n");
		return;
	}

	if(svs.phostclient->pedict->state.health <= 0)
	{
		Con_Printf("Can't save with dead player.\n");
		return;
	}

	// Create a game save
	if(gSaveRestore.CreateSaveFile(AUTOSAVE_FILE_NAME, SAVE_AUTO, nullptr, nullptr, (g_pCvarKeepOldSaves->GetValue() >= 1) ? true : false))
	{
		// Show the message
		svs.dllfuncs.pfnShowAutoSaveGameMessage();

		// Skip frame because we could have a major time-buildup
		ens.skipframe = true;
	}
	else
	{
		// Show the message
		svs.dllfuncs.pfnShowSaveGameBlockedMessage();
	}
}

//=============================================
// @brief Saves the game state to a file
// 
//=============================================
void Cmd_Load( void )
{
	if(svs.maxclients > 1)
	{
		Con_Printf("Save loading is not allowed in multiplayer.\n");
		return;
	}

	if(gCommands.Cmd_Argc() < 2)
	{
		Con_Printf("load usage: load <save file name>.\n");
		return;
	}

	CString savefile;
	CString cmdarg = gCommands.Cmd_Argv(1);

	if(!qstrcmp(cmdarg, QUICKSAVE_FILE_NAME))
	{
		if(!gSaveRestore.GetMostRecentSave(&savefile))
		{
			Con_Printf("No latest save file.\n");
			return;
		}
	}
	else
	{
		savefile << cmdarg;
		if(cmdarg.find(0, SAVE_FILE_EXTENSION) == -1)
			savefile << SAVE_FILE_EXTENSION;
	}

	SV_SpawnGame(nullptr, savefile.c_str());
}

//=============================================
// @brief
// 
//=============================================
void Cmd_God( void )
{
	Int32 invokerClient = gCommands.GetInvokerPlayerIndex();
	if(invokerClient == NO_ENTITY_INDEX)
	{
		Con_Printf("%s - Illegal call with no invoker.\n", __FUNCTION__);
		return;
	}

	if(invokerClient < 0 || invokerClient >= (Int32)svs.maxclients)
	{
		Con_Printf("%s - Illegal client index %d.\n", __FUNCTION__, invokerClient);
		return;
	}

	edict_t* pedict = svs.clients[invokerClient].pedict;
	if(pedict->state.flags & FL_GODMODE)
	{
		Con_Printf("godmode off.\n");
		pedict->state.flags &= ~FL_GODMODE;
	}
	else
	{
		Con_Printf("godmode on.\n");
		pedict->state.flags |= FL_GODMODE;
	}
}

//=============================================
// @brief
// 
//=============================================
void Cmd_Notarget( void )
{
	Int32 invokerClient = gCommands.GetInvokerPlayerIndex();
	if(invokerClient == NO_ENTITY_INDEX)
	{
		Con_Printf("%s - Illegal call with no invoker.\n", __FUNCTION__);
		return;
	}

	if(invokerClient < 0 || invokerClient >= (Int32)svs.maxclients)
	{
		Con_Printf("%s - Illegal client index %d.\n", __FUNCTION__, invokerClient);
		return;
	}

	edict_t* pedict = svs.clients[invokerClient].pedict;
	if(pedict->state.flags & FL_NOTARGET)
	{
		Con_Printf("notarget off.\n");
		pedict->state.flags &= ~FL_NOTARGET;
	}
	else
	{
		Con_Printf("notarget on.\n");
		pedict->state.flags |= FL_NOTARGET;
	}
}

//=============================================
// @brief
// 
//=============================================
void Cmd_Noclip( void )
{
	Int32 invokerClient = gCommands.GetInvokerPlayerIndex();
	if(invokerClient == NO_ENTITY_INDEX)
	{
		Con_Printf("%s - Illegal call with no invoker.\n", __FUNCTION__);
		return;
	}

	if(invokerClient < 0 || invokerClient >= (Int32)svs.maxclients)
	{
		Con_Printf("%s - Illegal client index %d.\n", __FUNCTION__, invokerClient);
		return;
	}

	edict_t* pedict = svs.clients[invokerClient].pedict;
	if(pedict->state.movetype == MOVETYPE_NOCLIP)
	{
		Con_Printf("noclip off.\n");
		pedict->state.movetype = MOVETYPE_WALK;
	}
	else
	{
		Con_Printf("noclip on.\n");
		pedict->state.movetype = MOVETYPE_NOCLIP;
	}
}

//=============================================
// @brief
// 
//=============================================
void Cmd_Restart( void )
{
	if(ens.isinprocesstringcommand)
	{
		Con_Printf("This function cannot be called from SV_ProcessStringCommand.\n");
		return;
	}

	if(svs.serverstate != SV_ACTIVE)
	{
		Con_Printf("Only the server may restart the game.\n");
		return;
	}

	// Draw loading screen before clearing
	VID_BeginLoading(true);

	// Remember map name
	CString mapname(svs.mapname);

	// Clear the game
	SV_ClearGame();

	SV_SpawnGame(mapname.c_str());
}

//=============================================
// @brief
// 
//=============================================
void Cmd_Reload( void )
{
	if(!svs.dllfuncs.pfnCanLoadGame())
	{
		Con_DPrintf("Load game blocked by game dll.\n");
		return;
	}

	if(ens.isinprocesstringcommand)
	{
		Con_Printf("This function cannot be called from SV_ProcessStringCommand.\n");
		return;
	}

	if(svs.serverstate != SV_ACTIVE)
	{
		Con_Printf("No active game.\n");
		return;
	}

	// Clear the game
	SV_ClearGame();

	CString savefile;
	if(gSaveRestore.GetMostRecentSave(&savefile))
		SV_SpawnGame(nullptr, savefile.c_str());
}

//=============================================
// @brief
// 
//=============================================
void Cmd_Snapshot( void )
{
	// Create screenshots directory
	if(!FL_CreateDirectory("screenshots"))
	{
		Con_Printf("Failed to create screenshots directory.\n");
		return;
	}

	// Draw the screen contents
	VID_Draw();

	// Check for errors
	if(rns.fatalerror)
	{
		Con_EPrintf("Error encountered during rendering.\n");
		return;
	}

	Uint32 width = gWindow.GetWidth();
	Uint32 height = gWindow.GetHeight();

	Uint32 size = width*height*3;
	byte* ppixeldata = new byte[size];

	glReadPixels(0, 0, width, height, GL_RGB, GL_UNSIGNED_BYTE, ppixeldata);

	// Determine filename
	CString filenamebase;
	if(ens.gamestate != GAME_RUNNING || gMenu.IsActive())
	{
		filenamebase << "snapshot";
	}
	else
	{
		CString basename;
		Common::Basename(ens.pworld->name.c_str(), basename);

		filenamebase << basename;
	}

	// Buffer containing TGA file data
	byte* pbuffer = nullptr;
	// Size of data to be written
	Uint32 datasize = 0;

	// Build file path
	CString outputname;
	outputname << "screenshots" << PATH_SLASH_CHAR << filenamebase << "-" << "%number%" << ".tga";

	TGA_BuildFile(ppixeldata, 3, width, height, pbuffer, datasize);
	delete[] ppixeldata;

	if(!FWT_AddFile(outputname.c_str(), pbuffer, datasize, true, true))
	{
		Int32 i = 0;
		CString finaloutputname;

		while(true)
		{
			finaloutputname = outputname;
			Int32 pos = finaloutputname.find(0, "%number%");
			if(pos == -1)
			{
				delete[] pbuffer;
				return;
			}

			CString numstr;
			numstr << i;

			finaloutputname.erase(pos, 8);
			finaloutputname.insert(pos, numstr.c_str());
			if(!FL_FileExists(finaloutputname.c_str()))
				break;

			i++;
		}

		bool result = FL_WriteFile(pbuffer, datasize, finaloutputname.c_str());
		if(result)
			Con_Printf("Wrote '%s'.\n", finaloutputname.c_str());
		else
			Con_Printf("Failed to write '%s'.\n", finaloutputname.c_str());		
	}

	delete[] pbuffer;
}

//=============================================
// @brief Forwards a command to the server
// 
//=============================================
void Cmd_ForwardToServer( void )
{
	gCommands.ForwardToServer();
}

//=============================================
// @brief
// 
//=============================================
void Cmd_ChangeLevel( void )
{
	if(ens.isinprocesstringcommand)
	{
		Con_Printf("This function cannot be called from SV_ProcessStringCommand.\n");
		return;
	}

	if(svs.serverstate != SV_ACTIVE)
	{
		Con_Printf("No active game.\n");
		return;
	}

	if(svs.maxclients > 1)
	{
		Con_Printf("Not allowed in multiplayer.\n");
		return;
	}

	if(gCommands.Cmd_Argc() < 3)
	{
		Con_Printf("changelevel usage: changelevel <level name> <landmark name>.\n");
		return;
	}

	const Char* pstrLevelName = gCommands.Cmd_Argv(1);
	const Char* pstrLandmarkName = gCommands.Cmd_Argv(2);

	SV_PerformLevelChange(pstrLevelName, pstrLandmarkName);
}

#define BUILD_TIME __TIME__ " " __DATE__

void GetWindowsVersion() {
	OSVERSIONINFOEX osvi;
	ZeroMemory(&osvi, sizeof(OSVERSIONINFOEX));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
	if (GetVersionEx((LPOSVERSIONINFO)&osvi)) {
		Con_Printf("Windows NT Version: %d.%d\n", osvi.dwMajorVersion, osvi.dwMinorVersion);
	}
	else {
		Con_Printf("Failed to retrieve Windows version.\n");
	}
}

#pragma comment(lib, "Advapi32.lib")

void GetCPUInfo() {
	HKEY hKey;
	LONG lResult;
	char cpuName[256];
	DWORD dwSize = sizeof(cpuName);

	lResult = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
		"HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0",
		0,
		KEY_READ,
		&hKey);
	if (lResult == ERROR_SUCCESS) {
		lResult = RegQueryValueEx(hKey,
			"ProcessorNameString",
			NULL,
			NULL,
			(LPBYTE)cpuName,
			&dwSize);
		if (lResult == ERROR_SUCCESS) {
			Con_Printf("CPU Name: %s\n", cpuName);
		}
		else {
			Con_Printf("Failed to retrieve CPU name.\n");
		}
		RegCloseKey(hKey);
	}
	else {
		Con_Printf("Failed to open registry key for CPU information.\n");
	}
}

void GetGPUInfo() {
	DISPLAY_DEVICE dd;
	ZeroMemory(&dd, sizeof(dd));
	dd.cb = sizeof(dd);
	if (EnumDisplayDevices(NULL, 0, &dd, 0)) {
		Con_Printf("GPU Name: %s\n", dd.DeviceString);
	}
	else {
		Con_Printf("Failed to retrieve GPU information.\n");
	}
}

void GetMemoryInfo() {
	MEMORYSTATUSEX statex;
	statex.dwLength = sizeof(statex);
	if (GlobalMemoryStatusEx(&statex)) {
		Con_Printf("Total System Memory: %lld MB\n", statex.ullTotalPhys / (1024 * 1024));
	}
	else {
		Con_Printf("Failed to retrieve memory information.\n");
	}
}

void Cmd_Debug() {
	Con_Printf("Engine Version Information:\n");
	Con_Printf("Build Time: %s\n", BUILD_TIME);
	GetWindowsVersion();
	GetCPUInfo();
	GetGPUInfo();
	GetMemoryInfo();
}

//=============================================
// @brief Creates the system commands
// 
//=============================================
void Sys_InitCommands( void )
{
	gCommands.CreateCommand("pause", Cmd_Pause, "Pauses the game");
	gCommands.CreateCommand("pos", Cmd_Pos, "Position of the player in the world");
	gCommands.CreateCommand("quit", Cmd_Sys_Quit, "Exits the application");
	gCommands.CreateCommand("map", Cmd_LoadMap, "Loads a map");
	gCommands.CreateCommand("maps", Cmd_ListMaps, "List of all maps");
	gCommands.CreateCommand("save", Cmd_Save, "Saves the game");
	gCommands.CreateCommand("quicksave", Cmd_QuickSave, "Creates a quicksave");
	gCommands.CreateCommand("autosave", Cmd_AutoSave, "Creates an autosave");
	gCommands.CreateCommand("load", Cmd_Load, "Loads a save file");
	gCommands.CreateCommand("reload", Cmd_Reload, "Reloads the most recent save");
	gCommands.CreateCommand("restart", Cmd_Restart, "Restarts the game");
	gCommands.CreateCommand("snapshot", Cmd_Snapshot, "Creates a screenshot");
	gCommands.CreateCommand("changelevel", Cmd_ChangeLevel, "Performs a level change", CMD_FL_SERVERCOMMAND);
	gCommands.CreateCommand("god", Cmd_God, "Toggles godmode cheat", (CMD_FL_SERVERCOMMAND|CMD_FL_CL_RELEVANT|CMD_FL_CHEAT));
	gCommands.CreateCommand("notarget", Cmd_Notarget, "Toggles notarget cheat", (CMD_FL_SERVERCOMMAND|CMD_FL_CL_RELEVANT|CMD_FL_CHEAT));
	gCommands.CreateCommand("noclip", Cmd_Noclip, "Toggles noclip cheat", (CMD_FL_SERVERCOMMAND|CMD_FL_CL_RELEVANT|CMD_FL_CHEAT));
	gCommands.CreateCommand("debuginfo", Cmd_Debug, "Debug info.");
}

//=============================================
// @brief Creates the system cvars
// 
//=============================================
void Sys_InitCVars( void )
{
	// Port
	g_pCVarPort = gConsole.CreateCVar(CVAR_FLOAT, (FL_CV_CLIENT|FL_CV_NONE), "net_port", "8099", "Port.");
}