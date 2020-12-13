@echo off
rem chcp 65001 > nul 2>&1

rem ****************
rem ���ʏ����ݒ�T�u�o�b�`
rem ****************


rem ****************
rem ����
rem ****************
set EXIT_CODE_NORMAL=0
set EXIT_CODE_ERROR=-1
set BASE_PATH=C:\mybatch
set BASE_LOG_PATH=D:\mybatch\log
set BASE_WORK_PATH=D:\mybatch\work
set JAR_PATH=C:\mybatch\java


rem ****************
rem ���ʃo�b�`
rem ****************
set COM_ALARM_IPMESSENGER=C:\mybatch\IPMessenger\ipmsg.exe


rem ****************
rem �o�b�N�A�b�v�p�p�X
rem ****************

set SYNC_LOG_PATH=%BASE_LOG_PATH%\backup
set SYNC_TO_BASE_PATH=E:\backup

rem ����p�x�o�b�N�A�b�v
set SYNC_FROM_PATH_211=D:
set SYNC_TO_PATH_211=%SYNC_TO_BASE_PATH%\��p�x�o�b�N�A�b�v\�V�X�e���f�[�^
set SYNC_OPTION_211=/xd "D:\datas\Chrome" /xd "D:\datas\log\backup"

rem �����p�x�o�b�N�A�b�v
set SYNC_FROM_PATH_210=C:\Users\%USERNAME%\�f�X�N�g�b�v
set SYNC_TO_PATH_210=%SYNC_TO_BASE_PATH%\���p�x�o�b�N�A�b�v\�f�X�N�g�b�v


rem ****************
rem �s���ȃu���E�U�L���b�V���̃`�F�b�N�p�p�X
rem ****************

set CACHE_LOG_PATH=%BASE_LOG_PATH%\chrome

set CACHE_FIND_PATH=D:\_datas\Chrome\Default\Cache


rem ****************
rem �X�^�[�g�A�b�v�`�F�b�N�p�p�X
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
rem �C�x���g���O���W�p�p�X
rem ****************

set EVENT_LOG_WORK_PATH=%BASE_WORK_PATH%\getEventLog
set EVENT_LOG_PATH=%BASE_LOG_PATH%\eventlog


rem ****************
rem ���O���W�p�p�X
rem ****************

set BACKUP_SYSTEM_MATERIAL_PATH=E:\backup\�V�X�e��\����V�X�e���o�b�N�A�b�v
set LOG_DEPLOY_DST_PATH=%BASE_WORK_PATH%\logDeploy

rem ���̃o�b�`���g�p���郌�|�[�g�t�@�C���̃p�X
set EVENT_REPORT_PATH=%BASE_WORK_PATH%\getEventLog\report
set EVENT_REPORT_BKUP_FILE=report_bkup.txt
set EVENT_REPORT_BWCH_FILE=report_bwch.txt
set EVENT_REPORT_CHST_FILE=report_chst.txt
set EVENT_REPORT_EVLG_SYS_FILE=report_evlg_sys.txt
set EVENT_REPORT_EVLG_SEC_FILE=report_evlg_sec.txt
set EVENT_REPORT_EVLG_DEF_FILE=report_evlg_def.txt


exit /b %EXIT_CODE_NORMAL%
