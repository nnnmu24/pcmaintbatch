@echo off
rem chcp 65001 > nul 2>&1

rem ****************
rem 共通初期設定サブバッチ
rem ****************


rem ****************
rem 共通
rem ****************
set EXIT_CODE_NORMAL=0
set EXIT_CODE_ERROR=-1
set BASE_PATH=C:\mybatch
set BASE_LOG_PATH=D:\mybatch\log
set BASE_WORK_PATH=D:\mybatch\work
set JAR_PATH=C:\mybatch\java


rem ****************
rem 共通バッチ
rem ****************
set COM_ALARM_IPMESSENGER=C:\mybatch\IPMessenger\ipmsg.exe


rem ****************
rem バックアップ用パス
rem ****************

set SYNC_LOG_PATH=%BASE_LOG_PATH%\backup
set SYNC_TO_BASE_PATH=E:\backup

rem ■低頻度バックアップ
set SYNC_FROM_PATH_211=D:
set SYNC_TO_PATH_211=%SYNC_TO_BASE_PATH%\低頻度バックアップ\システムデータ
set SYNC_OPTION_211=/xd "D:\datas\Chrome" /xd "D:\datas\log\backup"

rem ■高頻度バックアップ
set SYNC_FROM_PATH_210=C:\Users\%USERNAME%\デスクトップ
set SYNC_TO_PATH_210=%SYNC_TO_BASE_PATH%\高頻度バックアップ\デスクトップ


rem ****************
rem 不正なブラウザキャッシュのチェック用パス
rem ****************

set CACHE_LOG_PATH=%BASE_LOG_PATH%\chrome

set CACHE_FIND_PATH=D:\_datas\Chrome\Default\Cache


rem ****************
rem スタートアップチェック用パス
rem ****************

set STARTUP_LOG_PATH=%BASE_LOG_PATH%\startup

set STARTUP_OUTPUT_FILE=%BASE_WORK_PATH%\checkStartup\startupList.txt
set STARTUP_OUTPUT_MASTER_FILE=%BASE_PATH%\support\startupListMaster.txt

set STARTUP_CHECK_DIR1=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
set STARTUP_CHECK_DIR2=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
set STARTUP_CHECK_REG1=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
set STARTUP_CHECK_REG2=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
set STARTUP_CHECK_REG3=HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
set STARTUP_CHECK_REG4=HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce


rem ****************
rem イベントログ収集用パス
rem ****************

set EVENT_LOG_WORK_PATH=%BASE_WORK_PATH%\getEventLog
set EVENT_LOG_PATH=%BASE_LOG_PATH%\eventlog


rem ****************
rem ログ収集用パス
rem ****************

set BACKUP_SYSTEM_MATERIAL_PATH=E:\backup\システム\定期システムバックアップ
set LOG_DEPLOY_DST_PATH=%BASE_WORK_PATH%\logDeploy

rem 他のバッチが使用するレポートファイルのパス
set EVENT_REPORT_PATH=%BASE_WORK_PATH%\getEventLog\report
set EVENT_REPORT_BKUP_FILE=report_bkup.txt
set EVENT_REPORT_BWCH_FILE=report_bwch.txt
set EVENT_REPORT_CHST_FILE=report_chst.txt
set EVENT_REPORT_EVLG_SYS_FILE=report_evlg_sys.txt
set EVENT_REPORT_EVLG_SEC_FILE=report_evlg_sec.txt
set EVENT_REPORT_EVLG_DEF_FILE=report_evlg_def.txt


exit /b %EXIT_CODE_NORMAL%
