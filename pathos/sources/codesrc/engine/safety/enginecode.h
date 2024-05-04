#ifndef ENGINECODE_H
#define ENGINECODE_H

#include <windows.h>
#include <string>

#define CORRECT_CODE "mySecretCode"

class EngineCode {
public:
    EngineCode();
    ~EngineCode();
    bool ShowCodeEntryWindow();
private:
    static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    HWND hWnd;
    HWND hEdit;
    HWND hOkButton;
    HWND hCancelButton;
    bool correctCodeEntered;
};

#endif