@echo off

rem ****************
rem �X�^�[�g�A�b�v�`�F�b�N�o�b�`
rem �����F�Ȃ�
rem �����F�ȉ����X�^�[�g�A�b�v�������W�i�t�@�C���ɕۑ��j���A�}�X�^���ƍ������Ȃ����m�F����B
rem       1.�t�H���_
rem       2.���W�X�g��
rem       3.�T�[�r�X
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


rem �X�^�[�g�A�b�v���̎��W��
set STARTUP_FILE="%STARTUP_OUTPUT_FILE%"
set STARTUP_FILE_MASTER="%STARTUP_OUTPUT_MASTER_FILE%"

echo �X�^�[�g�A�b�v�ꗗ > %STARTUP_FILE%


rem �X�^�[�g�A�b�v�Ɋւ���t�H���_
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo ���t�H���_ >> %STARTUP_FILE%
dir "%STARTUP_CHECK_DIR1%" | find /v "�󂫗̈�" | find /v "<DIR>          ." >> %STARTUP_FILE%
dir "%STARTUP_CHECK_DIR2%" | find /v "�󂫗̈�" | find /v "<DIR>          ." >> %STARTUP_FILE%

rem �X�^�[�g�A�b�v�Ɋւ��郌�W�X�g��
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo �����W�X�g�� >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG1%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG2%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG3%" >> %STARTUP_FILE%
reg query "%STARTUP_CHECK_REG4%" >> %STARTUP_FILE%

rem �T�[�r�X�̑S��
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo -------- >> %STARTUP_FILE%
echo ���T�[�r�X >> %STARTUP_FILE%
rem �����ł���"xxx_���l"�̃T�[�r�X�����O
set EXP001="cbdhsvc_"
set EXP002="CDPUserSvc_"
set EXP003="Connected Devices Platform ���[�U�[ �T�[�r�X_"
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
set EXP014="�z�X�g�̓���_"
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


rem ���|�[�g�t�@�C���p����
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

rem ������r
set DATE_TMP=%date%
set LOG_SUFFIX=%DATE_TMP:~0,4%%DATE_TMP:~5,2%%DATE_TMP:~8,2%
set LOG_FILE_PATH=%STARTUP_LOG_PATH%\startup_diff_log_%LOG_SUFFIX%.txt

powershell diff (cat '%STARTUP_FILE%') (cat '%STARTUP_FILE_MASTER%') > %LOG_FILE_PATH%
set ALARM_MESSAGE_MAIN=�y�X�^�[�g�A�b�v�Ď��z
set ALARM_MESSAGE_SUB=�X�^�[�g�A�b�v�ɕύX���������܂����B[%LOG_FILE_PATH%]
find /i "<=" %LOG_FILE_PATH%
if %errorlevel% == 0 (
    call comAlarm.bat %ALARM_MESSAGE_MAIN% %ALARM_MESSAGE_SUB%
    rem ���|�[�g�t�@�C���o��
    echo [HEAD]%NOWDATETIME%,�ُ픭��>> %EVENT_REPORT_PATH%\%EVENT_REPORT_CHST_FILE%
    exit /b %EXIT_CODE_NORMAL%
)
rem ���|�[�g�t�@�C���o��
echo [HEAD]%NOWDATETIME%,�ُ�Ȃ�>> %EVENT_REPORT_PATH%\%EVENT_REPORT_CHST_FILE%


exit /b %EXIT_CODE_NORMAL%
