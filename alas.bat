@rem
:: Alas Run Tool v3
:: Author: whoamikyo (https://kyo.ninja)
:: Version: 3.0
:: Last updated: 2020-09-08
:: https://github.com/LmeSzinc/AzurLaneAutoScript
@echo off
chcp | find "932" >NUL && set "IME=true" || set "IME=false"
if "%IME%"=="true" (
   echo =======================================================================================================================
   echo == Incorrect encoding, visit this link to correct: https://bit.ly/34t8ubY
   echo == You may not have classical backslashes, you may have problems to run ALAS
   start https://bit.ly/34t8ubY
   echo == To copy, select the link and CTRL+SHIFT+C
   echo =======================================================================================================================
   pause
   goto :eof
   )
pushd "%~dp0"
setlocal EnableDelayedExpansion
set "Version=3.0"
set "lastUpdated=2020-08-27"
:: Remote repo
set "Remoterepo=https://raw.githubusercontent.com/LmeSzinc/AzurLaneAutoScript/master/toolkit"

rem ================= Preparation =================

:: Set the root directory
set "root=%~dp0"
set "root=%root:~0,-1%"
cd "%root%"
rem call :ExitIfNotPython

rem ================= Variables =================

set "pyBin=%root%\toolkit\python.exe"
set "adbBin=%root%\toolkit\Lib\site-packages\adbutils\binaries\adb.exe"
set "gitBin=%root%\toolkit\Git\mingw64\bin\git.exe"
set "curlBin=%root%\toolkit\Git\mingw64\bin\curl.exe"
set "api_json=%root%\config\api_git.json"
set "AlasConfig=%root%\config\alas.ini"
set "template=%root%\config\template.ini"
set "gitFolder=%root%\.git"

:: Import main settings (%Language%, %Region%, %SystemType%).
call command\Get.bat Main
:: Import the Proxy setting and apply. Then show more info in Option6.
call :Emulator_SetupFirstRun
call command\Get.bat Proxy
call command\Get.bat InfoOpt1
:: If already deployed, show more info in Option3.
call command\Get.bat InfoOpt2
rem call command\Get.bat InfoOpt4
call command\Get.bat DeployMode

:: Start of Deployment
if "%IsUsingGit%"=="yes" if "%DeployMode%"=="unknown" ( xcopy /Y toolkit\config .git\ > NUL )
call :UpdateChecker_Alas
title ^| Alas Run Tool V3 ^| Branch: %BRANCH% ^| Git hash: %LAST_LOCAL_GIT% ^| commit date: %GIT_CTIME% ^|

rem ================= Menu =================

:MENU
cd "%root%"
cls
echo =======================================================================================================================
:: Uncomment to debug the configuration that imported from "config\deploy.ini"
rem echo == ^| Language: %Language% & echo Region: %Region% & echo SystemType: %SystemType%
rem echo == ^| http_proxy: %http_proxy% & echo https_proxy: %https_proxy%
echo ^| DeployMode: %DeployMode%
rem echo == ^| KeepLocalChanges: %KeepLocalChanges%
rem echo == ^| RealtimeMode: %RealtimeMode%
rem echo == ^| FirstRun: %FirstRun%
echo ^| IsUsingGit: %IsUsingGit%
echo ^| Serial: %SerialDeploy%
setLocal EnableDelayedExpansion
set "STR=^| Alas Run Tool %Version% ^|"
set "SIZE=119"
set "LEN=0"
:strLen_Loop
if not "!!STR:~%LEN%!!"=="" set /A "LEN+=1" & goto :strLen_Loop
set "equal========================================================================================================================"
set "spaces========================================================================================================================"
call echo %%equal:~0,%SIZE%%%
set /a "pref_len=%SIZE%-%LEN%-2"
set /a "pref_len/=2"
set /a "suf_len=%SIZE%-%LEN%-2-%pref_len%"
call echo %%spaces:~0,%pref_len%%%%%STR%%%%spaces:~0,%suf_len%%%=====
call echo %%equal:~0,%SIZE%%%
endLocal
echo.
echo =======================================================================================================================
echo. & echo  [*] Select your Server/GUI Language
      echo    ^|
      echo    ^|-- [1] EN
      echo    ^|
      echo    ^|-- [2] CN
      echo    ^|
      echo    ^|-- [3] JP
      echo    ^|
      echo    ^|-- [4] TW
      echo.
echo. & echo  [5] Updater
echo. & echo  [6] Settings
echo =======================================================================================================================
set choice=0
set /p choice= Please input the option and press ENTER:
echo =======================================================================================================================
if "%choice%"=="1" goto en
if "%choice%"=="2" goto cn
if "%choice%"=="3" goto jp
if "%choice%"=="4" goto tw
if "%choice%"=="5" goto Updater_menu
if "%choice%"=="6" goto setting
echo. & echo Please input a valid option.
pause > NUL
goto MENU

rem ================= OPTION 1 =================

:en
call command\ConfigAlas.bat AzurLanePackage com.YoStarEN.AzurLane
call :CheckBsBeta
rem :continue_en
rem call :AdbConnect
echo =======================================================================================================================
echo Python Found in %pyBin% Proceeding..
echo Opening alas_en.pyw in %root%
%pyBin% alas_en.pyw
echo Press any key to back main menu
pause > NUL
goto :MENU

rem ================= OPTION 2 =================

:cn
call :CheckBsBeta
rem call :AdbConnect
echo =======================================================================================================================
echo Python Found in %pyBin% Proceeding..
echo Opening alas_en.pyw in %root%
%pyBin% alas_cn.pyw
echo Press any key to back main menu
pause > NUL
goto :MENU

rem ================= OPTION 3 =================
:jp
call :CheckBsBeta
rem call :AdbConnect
echo =======================================================================================================================
echo Python Found in %pyBin% Proceeding..
echo Opening alas_en.pyw in %root%
%pyBin% alas_jp.pyw
echo Press any key to back main menu
pause > NUL
goto :MENU

rem ================= OPTION 4 =================
:tw
call :CheckBsBeta
rem call :AdbConnect
echo =======================================================================================================================
echo Python Found in %pyBin% Proceeding..
echo Opening alas_tw.pyw in %root%
%pyBin% alas_tw.pyw
echo Press any key to back main menu
pause > NUL
goto :MENU

rem ================= OPTION 5 =================
:Updater_menu
cls
setLocal EnableDelayedExpansion
set "STR3=^| Alas Updater Tool ^|"
set "SIZE=119"
set "LEN=0"
:strLen_Loop
if not "!!STR3:~%LEN%!!"=="" set /A "LEN+=1" & goto :strLen_Loop
set "equal========================================================================================================================"
set "spaces========================================================================================================================"
call echo %%equal:~0,%SIZE%%%
set /a "pref_len=%SIZE%-%LEN%-2"
set /a "pref_len/=2"
set /a "suf_len=%SIZE%-%LEN%-2-%pref_len%"
call echo =%%spaces:~0,%pref_len%%%%%STR3%%%%spaces:~0,%suf_len%%%====
call echo %%equal:~0,%SIZE%%%
endLocal
echo.
echo =======================================================================================================================
echo Chinese users may need setup proxy or region first, check if settings below are correct.
echo Region: %Region%
echo =======================================================================================================================
echo. & echo  [*] Choose a Option
      echo    ^|
      echo    ^|-- [1] Update Alas
      echo    ^|
      echo    ^|
      echo    ^|-- [2] Update dependencies (Toolkit)
      echo    ^|
      echo    ^|
      echo.
echo. & echo  [3] Settings
echo. & echo  [0] Return to the Main Menu
echo =======================================================================================================================
set choice=-1
set /p choice= Please input the option and press ENTER:
echo =======================================================================================================================
if "%choice%"=="1" goto Run_UpdateAlas
if "%choice%"=="2" goto update_toolkit
if "%choice%"=="3" goto Setting
if "%choice%"=="0" goto MENU
echo. & echo == Please input a valid option.
pause > NUL
goto Updater_menu

:Run_UpdateAlas
set source="origin"
if "%Region%"=="cn" set "source=gitee"
echo. & echo.
echo =======================================================================================================================
echo == Branch in use: %Branch%
echo == KeepLocalChanges is: %KeepLocalChanges%
echo =======================================================================================================================
set opt6_opt4_choice=0
echo. & echo == Change default Branch (master/dev), please enter T;
echo == To proceed update using Branch: %Branch%, please enter Y;
echo == Back to Updater menu, please enter N;
set /p opt6_opt4_choice= Press ENTER to cancel:
echo.
if /i "%opt6_opt4_choice%"=="T" (
   call command\Config.bat Branch
) else if /i "%opt6_opt4_choice%"=="Y" (
   goto proceed_alas
) else if /i "%opt6_opt4_choice%"=="N" (
   goto ReturnToMenu
) else (
   echo == Invalid input. Cancelled.
   goto ReturnToMenu
)
:proceed_alas
if "%KeepLocalChanges%"=="disable" (
   echo == GIT Found in %gitBin% Proceeding
   echo == Updating from %source% repository..
   %gitBin% fetch %source% %Branch%
   %gitBin% reset --hard %source%/%Branch%
   %gitBin% pull --ff-only %source% %Branch%
   echo == DONE!
   echo == Press any key to proceed
   pause > NUL
   goto Updater_menu
) else (
   echo == GIT Found in %gitBin% Proceeding
   echo == Updating from %source% repository..
   %gitBin% stash
   %gitBin% pull %source% %Branch%
   %gitBin% stash pop
   echo == DONE!
   echo == Press any key to proceed
   pause > NUL
   goto Updater_menu
)
echo. & echo Please re-run this batch to make the settings take effect.
echo Please re-run the "alas.bat" to make the settings take effect.
goto PleaseRerun

:update_toolkit
echo == is not done yet
pause > NUL
goto ReturnToSetting

rem ================= OPTION 5 =================

:Setting
cls
setLocal EnableDelayedExpansion
set "STR2=Advanced Settings="
set "SIZE=119"
set "LEN=0"
:strLen_Loop
if not "!!STR2:~%LEN%!!"=="" set /A "LEN+=1" & goto :strLen_Loop
set "equal========================================================================================================================"
set "spaces========================================================================================================================"
call echo %%equal:~0,%SIZE%%%
set /a "pref_len=%SIZE%-%LEN%-2"
set /a "pref_len/=2"
set /a "suf_len=%SIZE%-%LEN%-2-%pref_len%"
call echo =%%spaces:~0,%pref_len%%%%%STR2%%%%spaces:~0,%suf_len%%%=
call echo %%equal:~0,%SIZE%%%
endLocal
echo =======================================================================================================================
echo == Please re-run this batch to make any settings take effect
echo =======================================================================================================================
echo.
echo. & echo  [0] Return to the Main Menu
echo. & echo  [1] Select Download Region
echo. & echo  [2] Set Global Proxy
echo. & echo  [3] Emulator Auto-ADB Settings
echo. & echo  [4] (Disable/Enable) Keep local changes
echo. & echo  [5] Change default Branch to update (master/dev)
echo. & echo  [6] (Disable/Enable) Kill ADB server at each start
echo. & echo  [7] (Disable/Enable) ADB connect at each start
echo. & echo  [8] Replace ADB from chinese emulators
echo. & echo  [9] Why can't I toggle certain settings above?
echo. & echo  [10] Reset Settings
echo. & echo.
echo =======================================================================================================================
set opt2_choice=-1
set /p opt2_choice= Please input the index number of option and press ENTER:
echo. & echo.
if "%opt2_choice%"=="0" goto MENU
if "%opt2_choice%"=="1" goto Region_setting
if "%opt2_choice%"=="2" goto Proxy_setting
if "%opt2_choice%"=="3" goto Emulator_Setup
if "%opt2_choice%"=="4" goto Keep_local_changes
if "%opt2_choice%"=="5" goto Branch_setting
if "%opt2_choice%"=="6" goto settings_KilADBserver
if "%opt2_choice%"=="7" goto settings_ADBconnect
if "%opt2_choice%"=="8" goto menu_ReplaceAdb
if "%opt2_choice%"=="9" goto Reset_setting
if "%opt2_choice%"=="10" goto Reset_setting
echo Please input a valid option.
goto ReturnToSetting

:Region_setting
echo The current Download Region is: %Region%
echo Chinese users, it is recommended to switch to Gitee, Option [2]
echo [1] Origin (Github) ; [2] CN mirror (Gitee)
set opt3_choice=-1
set /p opt3_choice= Please input the option and press ENTER:
echo =======================================================================================================================
if "%opt3_choice%"=="1" ( call command\Config.bat Region origin && goto PleaseRerun )
if "%opt3_choice%"=="2" ( call command\Config.bat Region cn && goto PleaseRerun )
goto ReturnToSetting

:Realtime_mode
call command\Config.bat RealtimeMode
if "%FirstRun%"=="yes" ( set FirstRun=no && call command\Config.bat FirstRun %FirstRun% )
goto PleaseRerun

:Keep_local_changes
call command\Config.bat KeepLocalChanges
goto ReturnToSetting

:settings_KilADBserver
call command\Config.bat AdbKillServer
goto ReturnToSetting

:settings_ADBconnect
call command\Config.bat Adbconnect
goto ReturnToSetting

:Proxy_setting
call command\Get.bat Proxy
if "%state_globalProxy%"=="enable" (
   echo Global Proxy: enabled
) else ( echo Global Proxy: disabled ^(DEFAULT^) )
echo. & echo.
echo If Global Proxy is enabled, the Proxy Server of current CMD window will be:
echo     HTTP_PROXY  = %__proxyHost%:%__httpPort%
echo     HTTPS_PROXY = %__proxyHost%:%__httpsPort%
set opt6_opt3_choice=0
echo. & echo To (disable/enable) the Global Proxy, please enter T;
echo To reset to the default Proxy Server, please enter Y;
echo To customize the Proxy Host or Port, please enter N;
set /p opt6_opt3_choice= Press ENTER to cancel:
echo.
setlocal EnableDelayedExpansion
if /i "%opt6_opt3_choice%"=="T" (
   call command\Config.bat Proxy
) else if /i "%opt6_opt3_choice%"=="Y" (
   call command\Config.bat ProxyHost http://127.0.0.1
   call command\Config.bat Http 1080
   call command\Config.bat Https 1080
   echo The Proxy Server has been reset to the default.
   call command\Config.bat Proxy enable
) else if /i "%opt6_opt3_choice%"=="N" (
   set /p opt6_opt3_proxyHost= Please input - Proxy Host ^(DEFAULT http://127.0.0.1 ^):
   set /p opt6_opt3_httpPort= Please input - Http Port ^(DEFAULT 1080 ^):
   set /p opt6_opt3_httpsPort= Please input - Https Port ^(DEFAULT 1080 ^):
   if "!opt6_opt3_proxyHost!"=="" ( set "opt6_opt3_proxyHost=http://127.0.0.1" )
   if "!opt6_opt3_httpPort!"=="" ( set "opt6_opt3_httpPort=1080" )
   if "!opt6_opt3_httpsPort!"=="" ( set "opt6_opt3_httpsPort=1080" )
   call command\Config.bat ProxyHost !opt6_opt3_proxyHost!
   call command\Config.bat Http !opt6_opt3_httpPort!
   call command\Config.bat Https !opt6_opt3_httpsPort!
   echo.
   call command\Config.bat Proxy enable
   echo The custom Proxy Server has been set successfully.
   echo Please re-perform this step here to confirm the modification.
) else (
   echo Invalid input. Cancelled.
   goto ReturnToSetting
)
endlocal
echo. & echo Please re-run this batch to make the settings take effect.
echo Please re-run the "alas.bat" to make the settings take effect.
goto PleaseRerun

:Branch_setting
call command\Config.bat Branch
goto ReturnToSetting

:Reset_setting
echo. & echo After updating this batch, if the new settings cannot be toggled, you need to delete "config\deploy.ini". & echo But this will reset all the above settings to default.
set opt3_opt10_choice=0
echo. & echo To delete the settings, please enter Y;
set /p opt3_opt10_choice= Press ENTER to cancel:
echo.
if /i "%opt3_opt10_choice%"=="Y" (
   del /Q config\deploy.ini >NUL 2>NUL
   echo The "config\deploy.ini" has been deleted, please try changing the settings again.
) else ( echo Invalid input. Cancelled. )
goto ReturnToSetting

:menu_ReplaceAdb
cls
echo =======================================================================================================================
echo ======== Different version of ADB will kill each other when starting.
echo ==== Chinese emulators (NoxPlayer, LDPlayer, MemuPlayer, MuMuPlayer) use their own adb,
echo == instead of the one in system PATH, so when they start they kill the adb.exe that Alas is using
echo == so, you need replace the ADB in your emulator with the one Alas is using.
echo =======================================================================================================================
echo.
echo. & echo  [0] Return to the Main Menu
echo. & echo  [1] Replace NoxPlayer ADB
echo. & echo  [2] Replace LDplayer ADB
echo. & echo  [3] Replace Memu ADB
echo. & echo.
echo =======================================================================================================================
set opt4_choice=-1
set /p opt4_choice= Please input the index number of option and press ENTER:
echo. & echo.
if "%opt4_choice%"=="0" goto MENU
if "%opt4_choice%"=="1" goto replace_nox
if "%opt4_choice%"=="2" goto replace_ldplayer
if "%opt4_choice%"=="3" goto replace_memu
echo Please input a valid option.
goto menu_ReplaceAdb

rem ================= EMULATOR SETTINGS =================

:replace_nox
reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\DuoDianOnline\SetupInfo>nul 2>nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == NoxAppPlayer detected, Proceeding...
) else (
   echo =======================================================================================================================
   echo == NoxAppPlayer not detected
   echo Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
)
:NOX
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\DuoDianOnline\SetupInfo" /v InstallPath`) do set InstallPath=%%M
%adbBin% kill-server > nul 2>&1
"%InstallPath%\bin\nox_adb.exe" version | find /i "29.0.6-6198805" >NUL && set "MATCH=true" || set "MATCH=false"
if "%MATCH%"=="true" ( echo Version already match with ALAS ADB version && echo Press any key to back main menu && pause > NUL )
echo f | xcopy /Y "%InstallPath%\bin\adb.exe" "%InstallPath%\bin\adb.exe.bak" >nul
echo f | xcopy /Y "%InstallPath%\bin\nox_adb.exe" "%InstallPath%\bin\nox_adb.exe.bak" >nul
xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallPath%\bin\" >nul
echo f | xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallPath%\bin\nox_adb.exe" >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == Success
   echo == Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
) else (
   echo =======================================================================================================================
   echo == Error, you may not have permission to replace the file
   echo == try run this batch as administrator
   echo Press any key to back main menu
   pause > NUL
   goto :eof
)

:replace_ldplayer
set LDREG=HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer
reg query HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer>nul 2>nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == LDplayer detected, Proceeding...
) else (
   set LDREG=HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer64
   echo =======================================================================================================================
   echo == LDplayer64 detected, Proceeding...
)
:LD
for /f "usebackq tokens=2,* skip=2" %%L IN ( `reg query "%LDREG%" /v InstallDir`) do set InstallDir=%%M
%adbBin% kill-server > nul 2>&1
"%InstallDir%\adb.exe" version | find /i "29.0.6-6198805" >NUL && set "MATCH=true" || set "MATCH=false"
if "%MATCH%"=="true" ( echo Version already match with ALAS ADB version && echo Press any key to back main menu && pause > NUL )
echo f | xcopy /Y "%InstallDir%\adb.exe" "%InstallDir%\adb.exe.bak" >nul
xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallDir%\" >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == Success
   echo == Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
) else (
   echo =======================================================================================================================
   echo == Error, you may not have permission to replace the file
   echo == try run this batch as administrator
   echo Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
)

:process_checker
setlocal EnableDelayedExpansion
set process=(MEmu.exe Bluestacks.exe Nox.exe dnplayer.exe NemuHeadless.exe )
for %%i in %process% do (
   tasklist /nh /fi "IMAGENAME EQ %%i" 2>NUL | find /i /n "%%i">NUL
   if !ERRORLEVEL! EQU 0 ( CALL :ProcessFound %%i )
   
)
goto :eof

:ProcessFound
ECHO == %1 is running
echo =======================================================================================================================
if "%1"=="dnplayer.exe" goto process_ldplayer
if "%1"=="Nox.exe" goto process_nox
if "%1"=="MEmu.exe" goto process_memu
if "%1"=="Bluestacks.exe" goto process_bluestacks
goto :eof

:process_ldplayer
set LDREG=HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer
reg query HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer>nul 2>nul
if %errorlevel% equ 0 (
   echo == LDplayer 32 bit detected
   echo =======================================================================================================================
) else (
   set LDREG=HKEY_CURRENT_USER\SOFTWARE\XuanZhi\LDPlayer64
   echo == LDplayer 64 bit detected
   echo =======================================================================================================================
)
for /f "usebackq tokens=2,* skip=2" %%L IN ( `reg query %LDREG% /v InstallDir`) do set InstallDir=%%M
"%InstallDir%\adb.exe" version | find /i "29.0.6-6198805" >NUL && set "MATCH=true" || set "MATCH=false"
if "%MATCH%"=="false" (
   echo == Wrong ADB version...
   echo == We will replace your ADB, re-run your server choice after that you back to main menu
   echo =======================================================================================================================
   goto LD
)
rem %adbBin% devices | find /i "emulator-5554" >NUL && set "EMULATOR=true" || set "EMULATOR=false"
set "EMULATOR=true"
if "%EMULATOR%"=="true" (
   echo == Your LDplayer will be restarted, wait...
   @cd/d "%InstallDir%"
   dnconsole.exe quit --index all
   @cd/d "%root%"
   start command\taskkill.bat
   timeout /t 3 >nul
   %adbBin% kill-server
   %adbBin% devices >nul
   timeout /t 1 >nul
   start /d "%InstallDir%" dnplayer.exe
   echo Press any key to continue when your LDplayer completely started
   pause > nul
)
goto :eof

:process_nox
echo == NoxAppPlayer is detected
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\DuoDianOnline\SetupInfo" /v InstallPath`) do set InstallPath=%%M
"%InstallPath%\bin\nox_adb.exe" version | find /i "29.0.6-6198805" >NUL && set "MATCH=true" || set "MATCH=false"
if "%MATCH%"=="false" (
   echo == Wrong ADB version...
   echo == We will replace your ADB, re-run your server choice after that you back to main menu
   echo =======================================================================================================================
   goto NOX
)
goto :eof

:process_memu
echo == MEmu is detected
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MEmu" /v InstallLocation`) do set InstallLocation=%%M
"%InstallLocation%\MEmu\adb.exe" version | find /i "29.0.6-6198805" >NUL && set "MATCH=true" || set "MATCH=false"
if "%MATCH%"=="false" (
   echo == Wrong ADB version...
   echo == We will replace your ADB, re-run your server choice after that you back to main menu
   echo =======================================================================================================================
   goto MEMU
)
goto :eof

:process_bluestacks
echo == Bluestacks is detected
goto :eof

:ProcessNotFound
ECHO %1 is not running
echo =======================================================================================================================
goto :eof

rem ================= EMULATOR SETUP MENU =================

:Emulator_Setup
cls
if NOT exist config\alas.ini (
   echo f | xcopy config\template.ini config\alas.ini > nul
)
echo =======================================================================================================================
echo == It seems like this is the first time that you run this program
echo == You may need to configure the connection to your emulator
echo =======================================================================================================================
echo.
echo. & echo  [1] Manual Setup
echo. & echo  [2] NoxAppPlayer Automatic Connection
echo. & echo  [3] Bluestacks Hyper-V Beta Automatic Connection
echo. & echo  [4] MEmu Automatic Connection
echo. & echo  [0] Return to the Main Menu
echo. & echo.
echo =======================================================================================================================
set opt55_choice=-1
set /p opt55_choice= Please input the index number of option and press ENTER:
echo. & echo.
if "%opt55_choice%"=="1" call :Serial_setting
if "%opt55_choice%"=="2" goto Settings_NoxSerial
if "%opt55_choice%"=="3" goto Realtime_mode
if "%opt55_choice%"=="4" goto Settings_MemuSerial
if "%opt55_choice%"=="0" goto MENU
echo Please input a valid option.
goto Emulator_Setup

:Emulator_SetupFirstRun
cls
if "%FirstRun%"=="no" goto :eof
set FirstRun=yes
echo =======================================================================================================================
echo == It seems like this is the first time that you run this program
echo == You may need to configure the connection to your emulator
echo =======================================================================================================================
echo.
echo. & echo  [1] Manual Setup
echo. & echo  [2] NoxAppPlayer Automatic Connection
echo. & echo  [3] Bluestacks Hyper-V Beta Automatic Connection ( ONLY TO HYPER-V VERSION, FOR NORMAL BLUESTACKS USE MANUAL SETUP )
echo. & echo  [4] MEmu Automatic Connection
echo. & echo  [0] Return to the Main Menu
echo. & echo.
echo =======================================================================================================================
set opt55_choice=-1
set /p opt55_choice= Please input the index number of option and press ENTER:
echo. & echo.
if "%opt55_choice%"=="1" call :Serial_setting
if "%opt55_choice%"=="2" goto Settings_NoxSerial
if "%opt55_choice%"=="3" goto Realtime_mode
if "%opt55_choice%"=="4" goto Settings_MemuSerial
if "%opt55_choice%"=="0" goto MENU
echo Please input a valid option.
goto Emulator_SetupFirstRun

rem ================= MEMU SETTINGS =================

:replace_memu
reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MEmu >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == Memu detected, Proceeding...
) else (
   echo =======================================================================================================================
   echo == Memu not detected
   echo == Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
)
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MEmu" /v InstallLocation`) do set InstallLocation=%%M
%adbBin% kill-server > nul 2>&1
echo f | xcopy /Y "%InstallLocation%\MEmu\adb.exe" "%InstallLocation%\MEmu\adb.exe.bak" >nul
xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallLocation%\MEmu\" >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == Success
   echo == Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
) else (
   echo =======================================================================================================================
   echo == Error, you may not have permission to replace the file
   echo == try run this batch as administrator
   echo Press any key to back main menu
   pause > NUL
   goto ReturnToMenu
)

:Settings_MemuSerial
reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MEmu >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == MEmu detected, Proceeding...
   ) else (
   echo =======================================================================================================================
   echo == MEmu not detected
   echo == Press any key to back Emulator Settings Menu
   pause > NUL
   goto Emulator_Setup
   )
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MEmu" /v InstallLocation`) do set InstallLocation=%%M
%adbBin% kill-server > nul 2>&1
echo f | xcopy /Y "%InstallLocation%\MEmu\adb.exe" "%InstallLocation%\MEmu\adb.exe.bak" >nul
xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallLocation%\MEmu\" >nul
echo =======================================================================================================================
echo == Please input the instance of your MEmu
echo == if you have only one instance type 0 or press Enter
echo == the first instance will always be 0, and the subsequent ones will follow the numerical order
echo =======================================================================================================================
set index=0
set /p index= Please input the instance of your MEmu, Press C to back Emulator Settings Menu:
if /i "%index%"=="C" ( goto Emulator_Setup )
echo =======================================================================================================================
if "%index%"=="0" ( set folderName=MEmu ) else ( set folderName=MEmu_%index% )
set MEmuPathTemp=\MEmu\MemuHyperv VMs\
set MEmuPath=%folderName%\%folderName%.memu
set MEmuPath=%MEmuPath: =%
set MEmuBoxPath="%InstallLocation%%MEmuPathTemp%%MEmuPath%"
for /f tokens^=8delims^=^" %%e in ('findstr /i "5555" %MEmuBoxPath%') do ( set MEmuAdbPort=%%e )
echo %folderName% adb port:%MEmuAdbPort%
set SerialMEmu=127.0.0.1:%MEmuAdbPort%
echo =======================================================================================================================
echo == connecting at %SerialMEmu%
%adbBin% connect %SerialMEmu% | find /i "connected to" >nul
if errorlevel 1 (
   echo =======================================================================================================================
   echo == The connection was not successful on SERIAL: %SerialMEmu%
   echo == Check if your emulator is open and ADB debug is ON
   pause > NUL
   goto Settings_MemuSerial
) 
call command\Config.bat Serial %SerialMEmu%
if "%FirstRun%"=="yes" ( call command\ConfigTemplate.bat SerialTemplate %SerialMEmu% ) else ( call command\ConfigAlas.bat SerialAlas %SerialMEmu% )
set FirstRun=no
call command\Config.bat FirstRun %FirstRun%
echo =======================================================================================================================
echo == The connection was Successful on SERIAL: %SerialMEmu%
echo =======================================================================================================================
echo == Old Serial:      %SerialAlas%
echo == New Serial:      %SerialMEmu%
echo =======================================================================================================================
echo == The connection was Successful on SERIAL: %SerialMEmu%
echo. & echo Please re-run the "alas.bat" to make the settings take effect.
pause > NUL
goto PleaseRerun

:Settings_NoxSerial
reg query HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\DuoDianOnline\SetupInfo >nul
if %errorlevel% equ 0 (
   echo =======================================================================================================================
   echo == NoxAppPlayer detected, Proceeding...
   ) else (
   echo =======================================================================================================================
   echo == NoxAppPlayer not detected
   echo Press any key to back Emulator Settings Menu
   pause > NUL
   goto Emulator_Setup
   )
for /f "usebackq tokens=2,* skip=2" %%L in ( `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\DuoDianOnline\SetupInfo" /v InstallPath`) do set InstallPath=%%M
%adbBin% kill-server > nul 2>&1
echo f | xcopy /Y "%InstallPath%\bin\adb.exe" "%InstallPath%\bin\adb.exe.bak" >nul
echo f | xcopy /Y "%InstallPath%\bin\nox_adb.exe" "%InstallPath%\bin\nox_adb.exe.bak" >nul
xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallPath%\bin\" >nul
echo f | xcopy /Y toolkit\Lib\site-packages\adbutils\binaries\adb.exe "%InstallPath%\bin\nox_adb.exe" >nul
echo =======================================================================================================================
echo == Please input the instance of your Nox
echo == if you have only one instance type 0 or press Enter
echo == the first instance will always be 0, and the subsequent ones will follow the numerical order
echo =======================================================================================================================
set index=0
set /p index= Please input the instance of your Nox, press C to back Emulator Settings Menu:
if /i "%index%"=="C" ( goto Emulator_Setup )
if "%index%"=="0" ( set folderName=nox ) else ( set folderName=Nox_%index% )
set NoxPath=\Bin\BignoxVMS\%folderName%\%folderName%.vbox
set NoxPath=%NoxPath: =%
set vboxPath="%InstallPath%"%NoxPath%
for /f tokens^=8delims^=^" %%e in ('findstr /i "5555" %vboxPath%') do ( set NoxAdbPort=%%e )
set SerialNox=127.0.0.1:%NoxAdbPort%
echo =======================================================================================================================
echo == connecting at %SerialNox%
%adbBin% connect %SerialNox% | find /i "connected to" >nul
if errorlevel 1 (
   echo =======================================================================================================================
   echo == The connection was not successful on SERIAL: %SerialNox%
   echo == Check if your emulator is open and ADB debug is ON
   pause > NUL
   goto Settings_NoxSerial
)
call command\Config.bat Serial %SerialNox%
if "%FirstRun%"=="yes" ( call command\ConfigTemplate.bat SerialTemplate %SerialNox% ) else ( call command\ConfigAlas.bat SerialAlas %SerialNox% )
set FirstRun=no
call command\Config.bat FirstRun %FirstRun%
echo =======================================================================================================================
echo == The connection was Successful on SERIAL: %SerialNox%
echo =======================================================================================================================
echo == Old Serial:      %SerialAlas%
echo == New Serial:      %SerialNox%
echo =======================================================================================================================
echo == The connection was Successful on SERIAL: %SerialNox%
echo. & echo == Please re-run the "alas.bat" to make the settings take effect.
pause > NUL
goto PleaseRerun

:Serial_setting
echo =======================================================================================================================
echo == If you dont know what are doing, check our wiki first:
echo https://github.com/LmeSzinc/AzurLaneAutoScript/wiki
echo == Current Serial = %SerialDeploy%
echo == Enter your HOST:PORT eg: 127.0.0.1:5555
echo =======================================================================================================================
set serial_inputY=0
echo. & echo Would you like to change the current SERIAL?, please enter Y to proceed;
set /p serial_inputY= Press ENTER to cancel:
echo.
setlocal EnableDelayedExpansion
if /i "%serial_inputY%"=="Y" (
   set /p serial_input= Enter your HOST:PORT ^(DEFAULT 127.0.0.1:5555 ^):
   if "!serial_input!"=="" ( set "serial_input=127.0.0.1:5555" )
   echo =======================================================================================================================
   %adbBin% kill-server > nul 2>&1
   %adbBin% connect !serial_input! | find /i "connected to" >nul
   if errorlevel 1 (
      echo =======================================================================================================================
      echo The connection was not successful on SERIAL: !serial_input!
      echo == If you use LDplayer, Memu, NoxAppPlayer or MuMuPlayer, you may need replace your emulator ADB.
      echo == Check our wiki for more info
      pause > NUL
      start https://github.com/LmeSzinc/AzurLaneAutoScript/wiki/FAQ_en_cn
      goto Serial_setting
   ) else (
      echo =======================================================================================================================
      call command\Config.bat Serial !serial_input!
      if "%FirstRun%"=="yes" ( call command\ConfigTemplate.bat SerialTemplate !serial_input! ) else ( call command\ConfigAlas.bat SerialAlas !serial_input! )
      set FirstRun=no
      call command\Config.bat FirstRun %FirstRun%
      echo == The connection was Successful on SERIAL: !serial_input!
      echo. & echo Please re-run the "alas.bat" to make the settings take effect.
      pause > NUL
      goto PleaseRerun
   )
) else (
   echo Invalid input. Cancelled.
   goto Emulator_Setup
)
echo =======================================================================================================================
echo == Old Serial:      %SerialDeploy%
echo == New Serial:      !serial_input!
echo =======================================================================================================================
endlocal
echo. & echo Please re-run the "alas.bat" to make the settings take effect.
pause > NUL
goto PleaseRerun

:AdbConnect
if "%FirstRun%"=="yes" goto Emulator_Setup
if "%KillServer%"=="enable" ( %adbBin% kill-server > nul 2>&1 )
if "%AdbConnect%"=="disable" goto :eof
%adbBin% connect %SerialDeploy% | find /i "connected to" >nul
echo =======================================================================================================================
if errorlevel 1 (
   echo == The connection was not successful on SERIAL: %SerialDeploy%
   echo == If you use LDplayer, Memu, NoxAppPlayer or MuMuPlayer, you may need replace your emulator ADB.
   echo == Check our wiki for more info
   pause > NUL
   start https://github.com/LmeSzinc/AzurLaneAutoScript/wiki/FAQ_en_cn
   goto Serial_setting
   echo =======================================================================================================================
   ) else (
      %pyBin% -m uiautomator2 init
      echo =======================================================================================================================
      echo == The connection was Successful on SERIAL: %SerialDeploy%
   )
goto :eof

:CheckBsBeta
call :process_checker
if "%RealtimeMode%"=="disable" ( goto AdbConnect )
for /f skip^=1^ tokens^=17^ delims^=^" %%a in ('tasklist /fi "imagename eq bluestacks.exe" /fo:csv /v /fi "status ne NOT RESPONDING"') do ( set WINDOW=%%a )
rem set WINDOW=%WINDOW:"=%
set WINDOW=%WINDOW: =%
if not "%WINDOW%"=="BlueStacks" (
   set WINDOW=%WINDOW:~10,1%
   echo == BlueStacks instance %WINDOW% detected
) else (
   echo == Bluestacks instance 1 detected
)
if "%WINDOW%"=="BlueStacks" (
   set folderName=Android 
   ) else ( 
      set folderName=Android_%WINDOW% 
      )
set HYPERVREG=HKEY_LOCAL_MACHINE\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\%folderName%\Config
set HYPERVREG=%HYPERVREG: =%
echo == Connecting with realtime mode...

for /f "tokens=3" %%a in ('reg query %HYPERVREG% /v BstAdbPort') do (set /a port = %%a)
set SerialRealtime=127.0.0.1:%port%
echo =======================================================================================================================
if "%KillServer%"=="enable" (
   %adbBin% kill-server > nul 2>&1
   )
echo == connecting at %SerialRealtime%
%adbBin% connect %SerialRealtime% > nul
if "%FirstRun%"=="yes" (
   call command\Config.bat Serial %SerialRealtime%
   call command\ConfigTemplate.bat SerialTemplate %SerialRealtime%
   set FirstRun=no
   call command\Config.bat FirstRun %FirstRun%
) else (
   call command\ConfigAlas.bat SerialAlas %SerialRealtime%
   call command\Config.bat Serial %SerialRealtime%
)
echo =======================================================================================================================
echo == Old Serial:      %SerialAlas%
echo == New Serial:      %SerialRealtime%
echo =======================================================================================================================
%pyBin% -m uiautomator2 init
echo =======================================================================================================================
echo == The connection was Successful on SERIAL: %SerialRealtime%
goto :eof

rem ================= FUNCTIONS =================

REM :CheckAdbConnect
REM for /f "tokens=1*" %%g IN ('%adbBin% connect 127.0.0.1:5555') do set adbCheck=%%g
REM if "%adbCheck%"=="cannot"
REM echo %adbCheck%

:ReturnToSetting
echo. & echo Press any key to continue...
pause > NUL
goto Setting

:ReturnToMenu
echo =======================================================================================================================
echo == Press any key to back to main menu...
pause > NUL
goto MENU

:PleaseRerun
echo =======================================================================================================================
echo == Press any key to exit...
pause > NUL
exit

:ExitIfGit
:: Check whether already exist .git folder
if exist .git\ (
   echo =======================================================================================================================
   echo == The Initial Deployment has been done. Please delete the ".git" folder before performing this action.
   call :PleaseRerun
)
goto :eof

:ExitIfNotPython
if NOT exist toolkit\python.exe (
   echo =======================================================================================================================
   echo == The Initial Deployment was not done correctly. Please delete entire folder and reinstall from scratch.
   start https://github.com/LmeSzinc/AzurLaneAutoScript/wiki/Installation_en
   call :PleaseRerun
)

:UpdateChecker_Alas
if "%IsUsingGit%"=="no" goto :eof
if "%Region%"=="cn" goto UpdateChecker_AlasGitee
for /f %%i in ('%gitBin%  rev-parse --abbrev-ref HEAD') do set cfg_branch=%%i
"%curlBin%" -s https://api.github.com/repos/lmeszinc/AzurLaneAutoScript/commits/%cfg_branch%?access_token=%GithubToken% > "%root%\toolkit\api_git.json"
for /f "skip=1 tokens=2 delims=:," %%I IN (%root%\toolkit\api_git.json) DO IF NOT DEFINED sha SET sha=%%I
set sha=%sha:"=%
set sha=%sha: =%
for /f "skip=14 tokens=3 delims=:" %%I IN (%root%\toolkit\api_git.json) DO IF NOT DEFINED message SET message=%%I
set message=%message:"=%
set message=%message:,=%
set message=%message:\n=%
set message=%message:\n\n=%
set message=%message:(=%
set message=%message:)=%
SET message=%message:~1%
for /f %%i in ('%gitBin%  rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
for /f "delims=" %%i IN ('%gitBin% log -1 "--pretty=%%H"') DO set LAST_LOCAL_GIT=%%i
for /f "tokens=1,2" %%A in ('%gitBin% log -1 "--format=%%h %%ct" -- .') do (
set GIT_SHA1=%%A
call :gmTime GIT_CTIME %%B
)

:UpdateChecker_AlasGitee
if "%Region%"=="origin" goto time_parsed
for /f %%i in ('%gitBin%  rev-parse --abbrev-ref HEAD') do set cfg_branch=%%i
"%curlBin%" -s https://gitee.com/api/v5/repos/lmeszinc/AzurLaneAutoScript/commits/%cfg_branch% > "%root%\toolkit\api_git.json"
for /f "tokens=5 delims=:," %%I IN (%root%\toolkit\api_git.json) DO IF NOT DEFINED sha SET sha=%%I
set sha=%sha:"=%
set sha=%sha: =%
for /f "tokens=25 delims=:" %%I IN (%root%\toolkit\api_git.json) DO IF NOT DEFINED message SET message=%%I
set message=%message:"=%
set message=%message:,=%
set message=%message:\ntree=%
set message=%message:\n\n=%
set message=%message:(=%
set message=%message:)=%
SET message=%message:~1%
for /f %%i in ('%gitBin%  rev-parse --abbrev-ref HEAD') do set BRANCH=%%i
for /f "delims=" %%i IN ('%gitBin% log -1 "--pretty=%%H"') DO set LAST_LOCAL_GIT=%%i
for /f "tokens=1,2" %%A in ('%gitBin% log -1 "--format=%%h %%ct" -- .') do (
set GIT_SHA1=%%A
call :gmTime GIT_CTIME %%B
)

:time_parsed
if %LAST_LOCAL_GIT% == %sha% (
   echo =======================================================================================================================
   echo == ^| Remote Git hash:        ^| %sha%
   echo == ^| Remote Git message:     ^| %message%
   echo =======================================================================================================================
   echo == ^| Local Git hash:         ^| %LAST_LOCAL_GIT%
   echo == ^| Local commit date:      ^| %GIT_CTIME%
   echo == ^| Current Local Branch:   ^| %BRANCH%
   echo =======================================================================================================================
   echo == Your ALAS is updated, Press any to continue...
   pause > NUL
   goto :eof
) else (
   echo =======================================================================================================================
   echo == ^| Remote Git hash:       ^| %sha%
   echo == ^| Remote Git message:    ^| %message%
   echo =======================================================================================================================
   echo == ^| Local Git hash:        ^| %LAST_LOCAL_GIT%
   echo == ^| Local commit date:     ^| %GIT_CTIME%
   echo == ^| Current Local Branch:  ^| %BRANCH%
   echo =======================================================================================================================
   popup.exe
   choice /t 10 /c yn /d y /m "There is an update for ALAS. Download now?"
   if errorlevel 2 goto :eof
   if errorlevel 1 goto Run_UpdateAlas
)

:gmtime
setlocal
set /a z=%2/86400+719468,d=z%%146097,y=^(d-d/1460+d/36525-d/146096^)/365,d-=365*y+y/4-y/100,m=^(5*d+2^)/153
set /a d-=^(153*m+2^)/5-1,y+=z/146097*400+m/11,m=^(m+2^)%%12+1
set /a h=%2/3600%%24,mi=%2%%3600/60,s=%2%%60
if %m% lss 10 set m=0%m%
if %d% lss 10 set d=0%d%
if %h% lss 10 set h=0%h%
if %mi% lss 10 set mi=0%mi%
if %s% lss 10 set s=0%s%
endlocal & set %1=%y%-%m%-%d% %h%:%mi%:%s%
goto :eof

rem ================= End of File =================
