@echo off

rem ****************
rem スタートアップチェックバッチ
rem 引数：なし
rem 説明：以下よりスタートアップ情報を収集（ファイルに保存）し、マスタ情報と差分がないか確認する。
rem       1.フォルダ
rem       2.レジストリ
rem       3.サービス
rem ****************

set MYSHELL_NAME=%0
echo [START]%MYSHELL_NAME%
echo [INFO]%date% %time%
echo [INFO]ユーザ名:%USERNAME%


rem ****************
rem 共通初期設定
rem ****************
cd /d %~dp0
call .\setenv.bat > nul 2>&1
if not %errorlevel% == 0 (
    echo [ERROR]setenvバッチ実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem スタートアップ情報の収集先
set STARTUP_FILE="%STARTUP_OUTPUT_FILE%"
set STARTUP_FILE_MASTER="%STARTUP_OUTPUT_MASTER_FILE%"

echo スタートアップ一覧 > %STARTUP_FILE%


rem スタートアップに関するフォルダ
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo ■フォルダ >> %STARTUP_FILE%
dir "%STARTUP_CHECK_DIR1%" | find /v "空き領域" | find /v "<DIR>          ." >> %STARTUP_FILE%
dir "%STARTUP_CHECK_DIR2%" | find /v "空き領域" | find /v "<DIR>          ." >> %STARTUP_FILE%

rem スタートアップに関するレジストリ
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo ■レジストリ >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG1%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG2%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG3%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG4%" >> %STARTUP_FILE%

rem サービスの全て
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo ■サービス >> %STARTUP_FILE%
rem 正当でかつ"xxx_数値"のサービスを除外
set EXP001="cbdhsvc_"
set EXP002="CDPUserSvc_"
set EXP003="Connected Devices Platform ユーザー サービス_"
set EXP004="Contact Data_"
set EXP005="OneSyncSvc_"
set EXP006="PimIndexMaintenanceSvc_"
set EXP007="PrintWorkflowUserSvc_"
set EXP008="UnistoreSvc_"
set EXP009="User Data Storage_"
set EXP010="User Data Access_"
set EXP011="UserDataSvc_"
set EXP012="Windows Push Notifications User Service_"
set EXP013="WpnUserService_"
set EXP014="ホストの同期_"
chcp 932 > nul 2>&1
sc query | find /i "DISPLAY" ^
    | find /v %EXP001% ^
    | find /v %EXP002% ^
    | find /v %EXP003% ^
    | find /v %EXP004% ^
    | find /v %EXP005% ^
    | find /v %EXP006% ^
    | find /v %EXP007% ^
    | find /v %EXP008% ^
    | find /v %EXP009% ^
    | find /v %EXP010% ^
    | find /v %EXP011% ^
    | find /v %EXP012% ^
    | find /v %EXP013% ^
    | find /v %EXP014% ^
    | sort ^
    >> %STARTUP_FILE%


rem レポートファイル用日時
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

rem 差分比較
set DATE_TMP=%date%
set LOG_SUFFIX=%DATE_TMP:~0,4%%DATE_TMP:~5,2%%DATE_TMP:~8,2%
set LOG_FILE_PATH=%STARTUP_LOG_PATH%\startup_diff_log_%LOG_SUFFIX%.txt

powershell diff (cat '%STARTUP_FILE%') (cat '%STARTUP_FILE_MASTER%') > %LOG_FILE_PATH%
set ALARM_MESSAGE_MAIN=【スタートアップ監視】
set ALARM_MESSAGE_SUB=スタートアップに変更が発生しました。[%LOG_FILE_PATH%]
find /i "<=" %LOG_FILE_PATH%
if %errorlevel% == 0 (
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,異常発生>> %EVENT_REPORT_PATH%\%EVENT_REPORT_CHST_FILE%
    exit /b %EXIT_CODE_NORMAL%
)
rem レポートファイル出力
echo [HEAD]%NOWDATETIME%,異常なし>> %EVENT_REPORT_PATH%\%EVENT_REPORT_CHST_FILE%


exit /b %EXIT_CODE_NORMAL%
