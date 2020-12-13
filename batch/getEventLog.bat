@echo off

rem ****************
rem イベントログ収集バッチ
rem 引数：なし
rem 説明：システム、セキュリティ、WindowsDefenderのイベントログを収集し解析
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
rem 事前処理
rem ****************

rem 日付要素を取得し変数に格納、当日と前日と30日前
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyyMMdd\")"`) do set DATE_TODAY=%%a
for /f "usebackq delims=" %%a in (`powershell "(get-date).AddDays(-1).ToString(\"yyyy-MM-dd\")"`) do set DATE_YESTERDAY=%%a
for /f "usebackq delims=" %%a in (`powershell "(get-date).AddDays(-30).ToString(\"yyyy-MM-dd\")"`) do set DATE_BEFMONTH=%%a

rem ログファイル
set LOG_SUFFIX=%DATE_TODAY%

rem システム、セキュリティ、WindowsDefenderのイベントログを格納するファイル
set SYSTEM_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_system_%LOG_SUFFIX%.txt
set SECUTITY_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_security_%LOG_SUFFIX%.txt
set DEFENDER_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_defender_%LOG_SUFFIX%.txt

rem システム、セキュリティ、WindowsDefenderのイベントログを解析したファイル
set SYSTEM_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_system_parsed_%LOG_SUFFIX%.txt
set SECUTITY_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_security_parsed_%LOG_SUFFIX%.txt
set DEFENDER_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_defender_parsed_%LOG_SUFFIX%.txt


rem ****************
rem イベントログの収集と解析
rem ****************

rem イベントログをwevtutilコマンドで収集
rem 収集対象は、前日23:50に本バッチを実行した以降の時刻
rem 時刻はGMT指定なので、前日23:50から9時間差し引く、つまり前日の14時50分

rem システムイベントログ
wevtutil qe System /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_YESTERDAY%T14:50:00']]]" > %SYSTEM_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil（system）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem セキュリティイベントログ
rem Securityは管理者権限で実行しないと取得できないので注意
wevtutil qe Security /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_YESTERDAY%T14:50:00']]]" > %SECUTITY_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil（security）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem WindowsDefenderイベントログ
rem これは30日前から収集
wevtutil qe "Microsoft-Windows-Windows Defender/Operational" /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_BEFMONTH%T14:50:00']]]" > %DEFENDER_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil（defender）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem イベントログの解析、javaで実施
set JARMJ=%JAR_PATH%\nnnmu24-local-eventlog.jar
set REPORT_SYS_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_SYS_FILE%
set REPORT_SEC_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_SEC_FILE%
set REPORT_DEF_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_DEF_FILE%

rem システムイベントログ
java -jar %JARMJ% 1 %SYSTEM_EVENT_LOG_WORK_FILE% %SYSTEM_EVENT_LOG_PARSE_FILE% %REPORT_SYS_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java（system）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem セキュリティイベントログ
java -jar %JARMJ% 2 %SECUTITY_EVENT_LOG_WORK_FILE% %SECUTITY_EVENT_LOG_PARSE_FILE% %REPORT_SEC_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java（security）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem WindowsDefenderイベントログ
java -jar %JARMJ% 3 %DEFENDER_EVENT_LOG_WORK_FILE% %DEFENDER_EVENT_LOG_PARSE_FILE% %REPORT_DEF_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java（defender）実行エラー
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem ****************
rem 解析結果の判定
rem ****************

rem イベントに警告や異常がある場合、解析後のイベントログファイルに[NOTICE!]という文字が含まれる。その文字を検出しアラームを通知する。
set ALARM_FLG=0
set ALARM_MESSAGE_MAIN=【イベントログ監視】
set ALARM_MESSAGE_SUB=アラームイベントが発生しました。
chcp 932 > nul 2>&1

rem システムイベントログ
find /i "[NOTICE!]" %SYSTEM_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%SYSTEM_EVENT_LOG_PARSE_FILE%]
)
rem セキュリティイベントログ
find /i "[NOTICE!]" %SECUTITY_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%SECUTITY_EVENT_LOG_PARSE_FILE%]
)
rem WindowsDefenderイベントログ
find /i "[NOTICE!]" %DEFENDER_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%DEFENDER_EVENT_LOG_PARSE_FILE%]
)

rem レポートファイル出力はJAVA内で実施する

rem アラーム通知
if %ALARM_FLG% == 1 (
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
)


exit /b %EXIT_CODE_NORMAL%
