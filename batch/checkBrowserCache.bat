@echo off

rem ****************
rem �s���ȃu���E�U�L���b�V���̃`�F�b�N�o�b�`
rem �����F�Ȃ�
rem �����F�u���E�U�̃L���b�V���t�H���_��蕶����ufiles://�v�̑��݂��m�F����B
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


set OUT_FILE=%CACHE_LOG_PATH%\cacheFindLog.txt
findstr /L /S /I "files://" %CACHE_FIND_PATH%\* > %OUT_FILE%

set COUNT=0
for /f "delims=" %%i in (%OUT_FILE%) do (
    set /a COUNT=COUNT+1
)

rem ���|�[�g�t�@�C���p����
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

if not %COUNT% == 0 (
    set ALARM_MESSAGE_MAIN=�y�s���ȃu���E�U�L���b�V���̃`�F�b�N�z
    set ALARM_MESSAGE_SUB=�댯�ȃL���b�V���t�@�C����������܂���[%COUNT%��]
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,�ُ픭��>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%
    echo [REPORT][NOTICE!]%NOWDATETIME%,ALARM_MESSAGE_SUB>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%
    exit /b %EXIT_CODE_NORMAL%
)
rem ���|�[�g�t�@�C���o��
echo [HEAD]%NOWDATETIME%,�ُ�Ȃ�>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BWCH_FILE%


exit /b %EXIT_CODE_NORMAL%
