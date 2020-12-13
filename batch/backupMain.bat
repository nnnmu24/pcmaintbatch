@echo off

rem ****************
rem �o�b�N�A�b�v���s�o�b�`
rem ��P�����F�o�b�N�A�b�v�Ώۃp�X��INDEX�isetenv.bat���ɋL�q�j
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
rem �����p�X�̎擾
rem ****************

rem ���|�[�g�t�@�C���p����
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

rem �p�X�̎擾
set PATH_INDEX=%1
setlocal enabledelayedexpansion
    rem ������INDEX�Ńp�X�ϐ������`��
    set SYNC_FROM_PATH_NAME=SYNC_FROM_PATH_%PATH_INDEX%
    set SYNC_TO_PATH_NAME=SYNC_TO_PATH_%PATH_INDEX%
    set SYNC_OPTION_NAME=SYNC_OPTION_%PATH_INDEX%

    rem �`�������ϐ����̒l���擾
    set SYNC_FROM_PATH_LOCAL=!%SYNC_FROM_PATH_NAME%!
    set SYNC_TO_PATH_LOCAL=!%SYNC_TO_PATH_NAME%!
    set SYNC_OPTION_LOCAL=!%SYNC_OPTION_NAME%!

rem ���[�J���ϐ����O���ɓK�p���邽�߁A�O���ϐ��ɃZ�b�g
endlocal && set SYNC_FROM_PATH=%SYNC_FROM_PATH_LOCAL% && set SYNC_TO_PATH=%SYNC_TO_PATH_LOCAL% && set SYNC_OPTION=%SYNC_OPTION_LOCAL%

if "%SYNC_FROM_PATH%" == "" (
    echo [ERROR]SYNC_FROM_PATH����`:����=%PATH_INDEX%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,���s>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,���,SYNC_FROM_PATH����`:����=%PATH_INDEX%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
if "%SYNC_TO_PATH%" == "" (
    echo [ERROR]SYNC_TO_PATH����`:����=%PATH_INDEX%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,���s>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,���,SYNC_TO_PATH����`:����=%PATH_INDEX%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)

rem �p�X�̑��݃`�F�b�N
if not exist "%SYNC_FROM_PATH%" (
    echo [ERROR]SYNC_FROM_PATH�s��:%SYNC_FROM_PATH%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,���s>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,���,SYNC_FROM_PATH�s��:%SYNC_FROM_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
if not exist "%SYNC_TO_PATH%" (
    echo [ERROR]SYNC_TO_PATH�s��:%SYNC_TO_PATH%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,���s>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,���,SYNC_TO_PATH�s��:%SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)


rem ****************
rem �������s
rem ****************

call .\backupSub.bat "%SYNC_FROM_PATH%" "%SYNC_TO_PATH%" "%SYNC_OPTION%"
if not %errorlevel% == %EXIT_CODE_NORMAL% (
    echo [ERROR]�������s
    echo [END]%MYSHELL_NAME%
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,���s>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME% %SYNC_FROM_PATH%�� %SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
rem ���|�[�g�t�@�C���o��
echo [HEAD]%NOWDATETIME%,����>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
echo [REPORT]%NOWDATETIME%,���,%SYNC_FROM_PATH%�� %SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%


echo [INFO]%date% %time%
echo [END]%MYSHELL_NAME%
echo ----
echo ----
exit /b %EXIT_CODE_NORMAL%

