@echo off

rem ****************
rem バックアップ実行サブバッチ
rem 第１引数：バックアップ元パス
rem 第２引数：バックアップ先パス
rem 第３引数：オプション
rem ****************


rem ログファイル名の生成
set DATE_TMP=%date%
set LOG_SUFFIX=%DATE_TMP:~0,4%%DATE_TMP:~5,2%%DATE_TMP:~8,2%
set LOG_FILE_PATH=%SYNC_LOG_PATH%\backup_schedule_log_%LOG_SUFFIX%.txt

echo [INFO]同期元パス:%~1
echo [INFO]同期先パス:%~2
echo [INFO]オプション:%~3
echo [INFO]ログファイルパス:%LOG_FILE_PATH%

rem robocopyでバックアップ
set RB_CMD_PARAM=%~1 %~2 /mir /copy:DT /z /r:1 /w:1 /xjd /ipg:10 /fft /np /ndl /log+:%LOG_FILE_PATH% /xd "System Volume Information" %~3
echo robocopy %RB_CMD_PARAM%
robocopy %RB_CMD_PARAM%
attrib -H -S %~2

exit /b %EXIT_CODE_NORMAL%
