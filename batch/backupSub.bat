@echo off

rem ****************
rem �o�b�N�A�b�v���s�T�u�o�b�`
rem ��P�����F�o�b�N�A�b�v���p�X
rem ��Q�����F�o�b�N�A�b�v��p�X
rem ��R�����F�I�v�V����
rem ****************


rem ���O�t�@�C�����̐���
set DATE_TMP=%date%
set LOG_SUFFIX=%DATE_TMP:~0,4%%DATE_TMP:~5,2%%DATE_TMP:~8,2%
set LOG_FILE_PATH=%SYNC_LOG_PATH%\backup_schedule_log_%LOG_SUFFIX%.txt

echo [INFO]�������p�X:%~1
echo [INFO]������p�X:%~2
echo [INFO]�I�v�V����:%~3
echo [INFO]���O�t�@�C���p�X:%LOG_FILE_PATH%

rem robocopy�Ńo�b�N�A�b�v
set RB_CMD_PARAM=%~1 %~2 /mir /copy:DT /z /r:1 /w:1 /xjd /ipg:10 /fft /np /ndl /log+:%LOG_FILE_PATH% /xd "System Volume Information" %~3
echo robocopy %RB_CMD_PARAM%
robocopy %RB_CMD_PARAM%
attrib -H -S %~2

exit /b %EXIT_CODE_NORMAL%
