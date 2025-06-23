--[[
    Version: 1.0.0
    Author: Ralsi (https://gamebanana.com/members/1939328)
    GB Page: https://gamebanana.com/tools/12925
    Crediting: If used in a mod, not necessary, but very much appreciated. Do not remove or edit all this info tho.
    Extra: To change the color that should be transparent, edit the line 27.
]]

    --massive thanks to Ralsi for porting this code to lua, makes my job easier lmao - snow

local fs, mx = false, false
local ffi = require("ffi")

local noMoreDeath = false

function onStepHit()
    if curStep >= 3840 and curStep < 4812 then 
        if buildTarget ~= 'windows' then
            onDestroy = function () end
            ffi, fs, mx = nil, nil, nil
            return
        end
        ffi.cdef([[
            typedef void* HWND;
            typedef int BOOL;
            typedef unsigned char BYTE;
            typedef unsigned long DWORD;
            HWND GetActiveWindow();
            long SetWindowLongA(HWND hWnd, int nIndex, long dwNewLong);
            BOOL SetLayeredWindowAttributes(HWND hwnd, DWORD crKey, BYTE bAlpha, DWORD dwFlags);
        ]])
        local hwnd = ffi.C.GetActiveWindow()
        ffi.C.SetWindowLongA(hwnd, -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(hwnd, 0x131313, 0, 0x00000001)
        addHaxeLibrary('Lib', 'openfl')
    end

    if curStep >= 4320 and curStep < 4816 then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end

    if curStep == 4528 then
        noMoreDeath = true
    end 

    if curStep >= 4816 and curStep < 4832 then
        if buildTarget ~= 'windows' then
            ffi, fs, mx = nil, nil, nil
            return
        end
        ffi.cdef([[
            typedef void* HWND;
            typedef int BOOL;
            typedef unsigned char BYTE;
            typedef unsigned long DWORD;
            HWND GetActiveWindow();
            long SetWindowLongA(HWND hWnd, int nIndex, long dwNewLong);
            BOOL SetLayeredWindowAttributes(HWND hwnd, DWORD crKey, BYTE bAlpha, DWORD dwFlags);
        ]])
        local hwnd = ffi.C.GetActiveWindow()
        ffi.C.SetWindowLongA(hwnd, -20, 0x00080000)
        ffi.C.SetLayeredWindowAttributes(hwnd, 0x131313, 0, 0x00000001)
        addHaxeLibrary('Lib', 'openfl')
    end

    if curStep >= 4858 then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end
end

function onDestroy()
    ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
end

function onGameOver()
    if not nomoreDeath then
        ffi.C.SetWindowLongA(ffi.C.GetActiveWindow(), -20, 0x00000000)
    end
end