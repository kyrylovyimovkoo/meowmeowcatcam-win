@echo off
cd /d "%~dp0"
title Meowmeow cat cam

if not exist "gesture_meme.py" (
    echo.
    echo BLAD: nie znalazlem pliku gesture_meme.py w tym folderze.
    echo Plik Uruchom.bat musi lezec obok gesture_meme.py oraz folderow memes i models.
    echo.
    pause
    exit /b 1
)

set PY=py
where py >nul 2>nul || set PY=python

if not exist ".venv\Scripts\python.exe" (
    echo Pierwsze uruchomienie - instaluje wszystko, 1-2 minuty...
    echo.
    %PY% -m venv .venv
    ".venv\Scripts\python.exe" -m pip install --upgrade pip
    ".venv\Scripts\python.exe" -m pip install -r requirements.txt
)

if not exist ".venv\Scripts\python.exe" (
    echo.
    echo BLAD: nie udalo sie utworzyc srodowiska. Sprawdz instalacje Pythona.
    echo.
    pause
    exit /b 1
)

echo Uruchamiam. Wyjscie: q lub Esc w oknie Camera.
".venv\Scripts\python.exe" gesture_meme.py

if errorlevel 1 (
    echo.
    echo Program zakonczyl sie bledem - komunikat masz powyzej.
    echo.
    pause
)
