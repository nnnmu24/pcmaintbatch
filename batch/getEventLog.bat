@echo off

rem ****************
rem �C�x���g���O���W�o�b�`
rem �����F�Ȃ�
rem �����F�V�X�e���A�Z�L�����e�B�AWindowsDefender�̃C�x���g���O�����W�����
rem ****************

set MYSHELL_NAME=%0
echo [START]%MYSHELL_NAME%
echo [INFO]%date% %time%
echo [INFO]���[�U��:%USERNAME%


rem ****************
rem ���ʏ����ݒ�
rem ****************

cd /d %~dp0
call .\setenv.bat > nul 2>&1
if not %errorlevel% == 0 (
    echo [ERROR]setenv�o�b�`���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem ****************
rem ���O����
rem ****************

rem ���t�v�f���擾���ϐ��Ɋi�[�A�����ƑO����30���O
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyyMMdd\")"`) do set DATE_TODAY=%%a
for /f "usebackq delims=" %%a in (`powershell "(get-date).AddDays(-1).ToString(\"yyyy-MM-dd\")"`) do set DATE_YESTERDAY=%%a
for /f "usebackq delims=" %%a in (`powershell "(get-date).AddDays(-30).ToString(\"yyyy-MM-dd\")"`) do set DATE_BEFMONTH=%%a

rem ���O�t�@�C��
set LOG_SUFFIX=%DATE_TODAY%

rem �V�X�e���A�Z�L�����e�B�AWindowsDefender�̃C�x���g���O���i�[����t�@�C��
set SYSTEM_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_system_%LOG_SUFFIX%.txt
set SECUTITY_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_security_%LOG_SUFFIX%.txt
set DEFENDER_EVENT_LOG_WORK_FILE=%EVENT_LOG_WORK_PATH%\event_log_defender_%LOG_SUFFIX%.txt

rem �V�X�e���A�Z�L�����e�B�AWindowsDefender�̃C�x���g���O����͂����t�@�C��
set SYSTEM_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_system_parsed_%LOG_SUFFIX%.txt
set SECUTITY_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_security_parsed_%LOG_SUFFIX%.txt
set DEFENDER_EVENT_LOG_PARSE_FILE=%EVENT_LOG_WORK_PATH%\event_log_defender_parsed_%LOG_SUFFIX%.txt


rem ****************
rem �C�x���g���O�̎��W�Ɖ��
rem ****************

rem �C�x���g���O��wevtutil�R�}���h�Ŏ��W
rem ���W�Ώۂ́A�O��23:50�ɖ{�o�b�`�����s�����ȍ~�̎���
rem ������GMT�w��Ȃ̂ŁA�O��23:50����9���ԍ��������A�܂�O����14��50��

rem �V�X�e���C�x���g���O
wevtutil qe System /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_YESTERDAY%T14:50:00']]]" > %SYSTEM_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil�isystem�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem �Z�L�����e�B�C�x���g���O
rem Security�͊Ǘ��Ҍ����Ŏ��s���Ȃ��Ǝ擾�ł��Ȃ��̂Œ���
wevtutil qe Security /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_YESTERDAY%T14:50:00']]]" > %SECUTITY_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil�isecurity�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem WindowsDefender�C�x���g���O
rem �����30���O������W
wevtutil qe "Microsoft-Windows-Windows Defender/Operational" /f:Text "/q:*[System[TimeCreated[@SystemTime>='%DATE_BEFMONTH%T14:50:00']]]" > %DEFENDER_EVENT_LOG_WORK_FILE%
if not %errorlevel% == 0 (
    echo [ERROR]wevtutil�idefender�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem �C�x���g���O�̉�́Ajava�Ŏ��{
set JARMJ=%JAR_PATH%\nnnmu24-local-eventlog.jar
set REPORT_SYS_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_SYS_FILE%
set REPORT_SEC_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_SEC_FILE%
set REPORT_DEF_PATH=%EVENT_REPORT_PATH%\%EVENT_REPORT_EVLG_DEF_FILE%

rem �V�X�e���C�x���g���O
java -jar %JARMJ% 1 %SYSTEM_EVENT_LOG_WORK_FILE% %SYSTEM_EVENT_LOG_PARSE_FILE% %REPORT_SYS_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java�isystem�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem �Z�L�����e�B�C�x���g���O
java -jar %JARMJ% 2 %SECUTITY_EVENT_LOG_WORK_FILE% %SECUTITY_EVENT_LOG_PARSE_FILE% %REPORT_SEC_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java�isecurity�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)
rem WindowsDefender�C�x���g���O
java -jar %JARMJ% 3 %DEFENDER_EVENT_LOG_WORK_FILE% %DEFENDER_EVENT_LOG_PARSE_FILE% %REPORT_DEF_PATH%
if not %errorlevel% == 100 if not %errorlevel% == 109 (
    echo [ERROR]java�idefender�j���s�G���[
    echo [END]%MYSHELL_NAME%
    exit /b %EXIT_CODE_ERROR%
)


rem ****************
rem ��͌��ʂ̔���
rem ****************

rem �C�x���g�Ɍx����ُ킪����ꍇ�A��͌�̃C�x���g���O�t�@�C����[NOTICE!]�Ƃ����������܂܂��B���̕��������o���A���[����ʒm����B
set ALARM_FLG=0
set ALARM_MESSAGE_MAIN=�y�C�x���g���O�Ď��z
set ALARM_MESSAGE_SUB=�A���[���C�x���g���������܂����B
chcp 932 > nul 2>&1

rem �V�X�e���C�x���g���O
find /i "[NOTICE!]" %SYSTEM_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%SYSTEM_EVENT_LOG_PARSE_FILE%]
)
rem �Z�L�����e�B�C�x���g���O
find /i "[NOTICE!]" %SECUTITY_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%SECUTITY_EVENT_LOG_PARSE_FILE%]
)
rem WindowsDefender�C�x���g���O
find /i "[NOTICE!]" %DEFENDER_EVENT_LOG_PARSE_FILE%
if %errorlevel% == 0 (
    set ALARM_FLG=1
    set ALARM_MESSAGE_SUB=%ALARM_MESSAGE_SUB%\r\n[%DEFENDER_EVENT_LOG_PARSE_FILE%]
)

rem ���|�[�g�t�@�C���o�͂�JAVA���Ŏ��{����

rem �A���[���ʒm
if %ALARM_FLG% == 1 (
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
)


exit /b %EXIT_CODE_NORMAL%
