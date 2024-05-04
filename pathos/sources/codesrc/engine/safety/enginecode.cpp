#include "enginecode.h"
#include <windows.h>

EngineCode::EngineCode()
    : correctCodeEntered(false),
    hWnd(nullptr),
    hEdit(nullptr),
    hOkButton(nullptr),
    hCancelButton(nullptr) {}

EngineCode::~EngineCode() {}

bool EngineCode::ShowCodeEntryWindow() {
    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = GetModuleHandle(nullptr);
    wc.lpszClassName = TEXT("EngineCodeWindow");

    RegisterClass(&wc);

    hWnd = CreateWindowEx(
        0,
        TEXT("EngineCodeWindow"),
        TEXT("Enter Code"),
        WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU,
        CW_USEDEFAULT, CW_USEDEFAULT, 300, 150,
        nullptr,
        nullptr,
        GetModuleHandle(nullptr),
        this
    );

    if (hWnd == nullptr) {
        return false;
    }

    ShowWindow(hWnd, SW_SHOW);

    MSG msg = {};
    while (GetMessage(&msg, nullptr, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
        if (msg.message == WM_QUIT) {
            break;
        }
    }

    return correctCodeEntered;
}

LRESULT CALLBACK EngineCode::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    EngineCode* pThis;

    if (uMsg == WM_NCCREATE) {
        pThis = static_cast<EngineCode*>(reinterpret_cast<CREATESTRUCT*>(lParam)->lpCreateParams);
        SetWindowLongPtr(hwnd, GWLP_USERDATA, reinterpret_cast<LONG_PTR>(pThis));
    }
    else {
        pThis = reinterpret_cast<EngineCode*>(GetWindowLongPtr(hwnd, GWLP_USERDATA));
    }

    if (!pThis) {
        return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }

    switch (uMsg) {
    case WM_CREATE: {
        pThis->hEdit = CreateWindowEx(
            0,
            TEXT("EDIT"),
            TEXT(""),
            WS_CHILD | WS_VISIBLE | WS_BORDER,
            50, 20, 200, 25,
            hwnd,
            nullptr,
            GetModuleHandle(nullptr),
            nullptr
        );

        pThis->hOkButton = CreateWindowEx(
            0,
            TEXT("BUTTON"),
            TEXT("OK"),
            WS_CHILD | WS_VISIBLE,
            50, 70, 75, 30,
            hwnd,
            reinterpret_cast<HMENU>(1),
            GetModuleHandle(nullptr),
            nullptr
        );

        pThis->hCancelButton = CreateWindowEx(
            0,
            TEXT("BUTTON"),
            TEXT("Cancel"),
            WS_CHILD | WS_VISIBLE,
            175, 70, 75, 30,
            hwnd,
            reinterpret_cast<HMENU>(2),
            GetModuleHandle(nullptr),
            nullptr
        );

        break;
    }

    case WM_COMMAND: {
        if (LOWORD(wParam) == 1) {
            wchar_t enteredCodeW[100];
            GetWindowTextW(pThis->hEdit, enteredCodeW, 100);
            int len = WideCharToMultiByte(CP_ACP, 0, enteredCodeW, -1, nullptr, 0, nullptr, nullptr);
            char* enteredCodeC = new char[len];
            WideCharToMultiByte(CP_ACP, 0, enteredCodeW, -1, enteredCodeC, len, nullptr, nullptr);

            std::string strEnteredCode(enteredCodeC);
            delete[] enteredCodeC;

            if (strEnteredCode == CORRECT_CODE) {
                pThis->correctCodeEntered = true;
                DestroyWindow(pThis->hWnd);
                PostQuitMessage(0);
            }
            else {
                MessageBox(hwnd, TEXT("Incorrect code."), TEXT("Error"), MB_ICONERROR);
            }
        }
        else if (LOWORD(wParam) == 2) {
            DestroyWindow(pThis->hWnd);
            exit(0);
        }

        break;
    }

    case WM_CLOSE:
        PostQuitMessage(0);
        return 0;

    default:
        return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }

    return 0;
}