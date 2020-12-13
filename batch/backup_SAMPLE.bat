@echo off

cd %BASE_PATH%
call backupMain.bat 210
call backupMain.bat 211

exit %EXIT_CODE_NORMAL%

