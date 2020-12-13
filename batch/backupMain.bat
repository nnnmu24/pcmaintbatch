@echo off

rem ****************
rem バックアップ実行バッチ
rem 第１引数：バックアップ対象パスのINDEX（setenv.bat内に記述）
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
rem 同期パスの取得
rem ****************

rem レポートファイル用日時
for /f "usebackq delims=" %%a in (`powershell "(get-date).ToString(\"yyyy/MM/dd HH:mm:ss\")"`) do set NOWDATETIME=%%a

rem パスの取得
set PATH_INDEX=%1
setlocal enabledelayedexpansion
    rem 引数のINDEXでパス変数名を形成
    set SYNC_FROM_PATH_NAME=SYNC_FROM_PATH_%PATH_INDEX%
    set SYNC_TO_PATH_NAME=SYNC_TO_PATH_%PATH_INDEX%
    set SYNC_OPTION_NAME=SYNC_OPTION_%PATH_INDEX%

    rem 形成した変数名の値を取得
    set SYNC_FROM_PATH_LOCAL=!%SYNC_FROM_PATH_NAME%!
    set SYNC_TO_PATH_LOCAL=!%SYNC_TO_PATH_NAME%!
    set SYNC_OPTION_LOCAL=!%SYNC_OPTION_NAME%!

rem ローカル変数を外部に適用するため、外部変数にセット
endlocal && set SYNC_FROM_PATH=%SYNC_FROM_PATH_LOCAL% && set SYNC_TO_PATH=%SYNC_TO_PATH_LOCAL% && set SYNC_OPTION=%SYNC_OPTION_LOCAL%

if "%SYNC_FROM_PATH%" == "" (
    echo [ERROR]SYNC_FROM_PATH未定義:引数=%PATH_INDEX%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,失敗>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,情報,SYNC_FROM_PATH未定義:引数=%PATH_INDEX%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
if "%SYNC_TO_PATH%" == "" (
    echo [ERROR]SYNC_TO_PATH未定義:引数=%PATH_INDEX%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,失敗>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,情報,SYNC_TO_PATH未定義:引数=%PATH_INDEX%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)

rem パスの存在チェック
if not exist "%SYNC_FROM_PATH%" (
    echo [ERROR]SYNC_FROM_PATH不正:%SYNC_FROM_PATH%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,失敗>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,情報,SYNC_FROM_PATH不正:%SYNC_FROM_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
if not exist "%SYNC_TO_PATH%" (
    echo [ERROR]SYNC_TO_PATH不正:%SYNC_TO_PATH%
    echo [END]%MYSHELL_NAME%
    echo ----
    echo ----
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,失敗>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME%,情報,SYNC_TO_PATH不正:%SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)


rem ****************
rem 同期実行
rem ****************

call .\backupSub.bat "%SYNC_FROM_PATH%" "%SYNC_TO_PATH%" "%SYNC_OPTION%"
if not %errorlevel% == %EXIT_CODE_NORMAL% (
    echo [ERROR]同期失敗
    echo [END]%MYSHELL_NAME%
    rem レポートファイル出力
    echo [HEAD]%NOWDATETIME%,失敗>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    echo [REPORT]%NOWDATETIME% %SYNC_FROM_PATH%→ %SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
    exit /b %EXIT_CODE_ERROR%
)
rem レポートファイル出力
echo [HEAD]%NOWDATETIME%,成功>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%
echo [REPORT]%NOWDATETIME%,情報,%SYNC_FROM_PATH%→ %SYNC_TO_PATH%>> %EVENT_REPORT_PATH%\%EVENT_REPORT_BKUP_FILE%


echo [INFO]%date% %time%
echo [END]%MYSHELL_NAME%
echo ----
echo ----
exit /b %EXIT_CODE_NORMAL%

