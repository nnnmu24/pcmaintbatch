@echo off

rem ****************
rem 不正なブラウザキャッシュのチェックバッチ
rem 引数：なし
rem 説明：ブラウザのキャッシュフォルダより文字列「files://」の存在を確認する。
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


set OUT_FILE=%CACHE_LOG_PATH%\cacheFindLog.txt
findstr /L /S /I "files://" %CACHE_FIND_PATH%\* > %OUT_FILE%

set COUNT=0
for /f "delims=" %%i in (%OUT_FILE%) do (
    set /a COUNT=COUNT+1
)

rem レポートファイル用日時
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

if not %COUNT% == 0 (
    set ALARM_MESSAGE_MAIN=【不正なブラウザキャッシュのチェック】
    set ALARM_MESSAGE_SUB=危険なキャッシュファイルが見つかりました[%COUNT%件]
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,異常発生>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%
    echo [REPORT][NOTICE!]%NOWDATETIME%,ALARM_MESSAGE_SUB>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%
    exit /b %EXIT_CODE_NORMAL%
)
rem レポートファイル出力
echo [HEAD]%NOWDATETIME%,異常なし>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%


exit /b %EXIT_CODE_NORMAL%
