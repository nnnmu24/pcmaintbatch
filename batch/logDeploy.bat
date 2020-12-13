@echo off

rem ****************
rem 最新ログファイル配置バッチ
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


rem ****************
rem 最新ログファイルのコピー
rem ****************

rem システムバックアップのログをコピー
set LOGCOPY_SYSBUP_DST=%LOG_DEPLOY_DST_PATH%\backup_system_log.txt
dir %BACKUP_SYSTEM_MATERIAL_PATH% > %LOGCOPY_SYSBUP_DST%

rem データバックアップのログをコピー
rem 最新の日付ファイルを対象
for /f "usebackq" %%i in (`dir /B /O:N %SYNC_LOG_PATH%\backup_schedule_log_*.txt`) do set LOGCOPY_DATABUP_TMP=%%i
call :SUBFUNC1 %SYNC_LOG_PATH%\%LOGCOPY_DATABUP_TMP% backup_schedule_log.txt

rem スタートアップチェックのログをコピー
rem 最新の日付ファイルを対象
for /f "usebackq" %%i in (`dir /B /O:N %STARTUP_LOG_PATH%\startup_diff_log_*.txt`) do set LOGCOPY_STARTUP_TMP=%%i
call :SUBFUNC1 %STARTUP_LOG_PATH%\%LOGCOPY_STARTUP_TMP% startup_diff_log.txt

rem イベントログ収集のログ（システム、セキュリティ、Defender）をコピー
rem 最新の日付ファイルを対象
for /f "usebackq" %%i in (`dir /B /O:N %EVENT_LOG_WORK_PATH%\event_log_system_parsed_*.txt`) do set LOGCOPY_EVENTLOG_SYS_TMP=%%i
call :SUBFUNC1 %EVENT_LOG_WORK_PATH%\%LOGCOPY_EVENTLOG_SYS_TMP% event_log_system_parsed.txt
for /f "usebackq" %%i in (`dir /B /O:N %EVENT_LOG_WORK_PATH%\event_log_security_parsed_*.txt`) do set LOGCOPY_EVENTLOG_SEC_TMP=%%i
call :SUBFUNC1 %EVENT_LOG_WORK_PATH%\%LOGCOPY_EVENTLOG_SEC_TMP% event_log_security_parsed.txt
for /f "usebackq" %%i in (`dir /B /O:N %EVENT_LOG_WORK_PATH%\event_log_defender_parsed_*.txt`) do set LOGCOPY_EVENTLOG_DEF_TMP=%%i
call :SUBFUNC1 %EVENT_LOG_WORK_PATH%\%LOGCOPY_EVENTLOG_DEF_TMP% event_log_defender_parsed.txt

rem 各レポートファイルをコピー
call :SUBFUNC2 %EVENT_REPORT_BKUP_FILE%
call :SUBFUNC2 %EVENT_REPORT_BWCH_FILE%
call :SUBFUNC2 %EVENT_REPORT_CHST_FILE%
call :SUBFUNC2 %EVENT_REPORT_EVLG_SYS_FILE%
call :SUBFUNC2 %EVENT_REPORT_EVLG_SEC_FILE%
call :SUBFUNC2 %EVENT_REPORT_EVLG_DEF_FILE%


rem ****************
rem まとめ
rem ****************

rem set STR_BKUP = find 
rem for /f %%i in ('findstr /L /S /I "[HEAD]" %EVENT_REPORT_BKUP_FILE%') do set 変数=%%STR_BKUP
rem echo %STR_BKUP% >> %LOG_DEPLOY_DST_PATH%\aaa.txt


exit /b %EXIT_CODE_NORMAL%


rem サブルーチン 詳細ログファイルのコピー
:SUBFUNC1
set LOGCOPY_EVENTLOG_SEC_SRC=%1
set LOGCOPY_EVENTLOG_SEC_DST=%LOG_DEPLOY_DST_PATH%\%2
if not exist "%LOGCOPY_EVENTLOG_SEC_SRC%" (
    echo [INFO]コピー元なし:%LOGCOPY_EVENTLOG_SEC_SRC%
    exit /b %EXIT_CODE_NORMAL%
)
echo [INFO]コピー元:%LOGCOPY_EVENTLOG_SEC_SRC%
echo [INFO]コピー先:%LOGCOPY_EVENTLOG_SEC_DST%
copy /Y %LOGCOPY_EVENTLOG_SEC_SRC% %LOGCOPY_EVENTLOG_SEC_DST%
call :SUBFUNC3 %LOGCOPY_EVENTLOG_SEC_DST%
if not %errorlevel% == %EXIT_CODE_NORMAL% (
    exit /b %EXIT_CODE_ERROR%
)
del /q %LOGCOPY_EVENTLOG_SEC_SRC%

exit /b %EXIT_CODE_NORMAL%


rem サブルーチン レポートファイルのコピー
:SUBFUNC2
set LOGCOPY_EVENTLOG_SEC_SRC=%EVENT_REPORT_PATH%\%1
set LOGCOPY_EVENTLOG_SEC_DST=%LOG_DEPLOY_DST_PATH%\%1
if not exist "%LOGCOPY_EVENTLOG_SEC_SRC%" (
    echo [INFO]コピー元なし:%LOGCOPY_EVENTLOG_SEC_SRC%
    exit /b %EXIT_CODE_NORMAL%
)
echo [INFO]コピー元:%LOGCOPY_EVENTLOG_SEC_SRC%
echo [INFO]コピー先:%LOGCOPY_EVENTLOG_SEC_DST%
copy /Y %LOGCOPY_EVENTLOG_SEC_SRC% %LOGCOPY_EVENTLOG_SEC_DST%
call :SUBFUNC3 %LOGCOPY_EVENTLOG_SEC_DST%
if not %errorlevel% == %EXIT_CODE_NORMAL% (
    exit /b %EXIT_CODE_ERROR%
)
del /q %LOGCOPY_EVENTLOG_SEC_SRC%

exit /b %EXIT_CODE_NORMAL%


rem サブルーチン UTF-8変換
:SUBFUNC3

set FILE_PATH=%1
cd /d %~dp0
call .\fileToUtf8.bat %FILE_PATH% > nul 2>&1
if not %errorlevel% == 0 (
    echo [ERROR]fileToUtf8バッチ実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
copy /Y %FILE_PATH%.utf8.txt %FILE_PATH%
del %FILE_PATH%.utf8.txt

exit /b %EXIT_CODE_NORMAL%
