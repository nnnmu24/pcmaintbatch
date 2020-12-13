# pcmaintbatch
Batch to perform home PC maintenance.  
download (https://github.com/nnnmu24/pcmaintbatch)


# 概要
  - 家庭向けのWindowsPCを保守するバッチ集。
  - データバックアップ
    robocopyコマンドによるデータファイルのバックアップ。  
  - ブラウザキャッシュチェック  
    セキュリティチェック用バッチ  
    ブラウザのキャッシュフォルダより文字列「files://」の存在を確認する。  
  - スタートアップ改竄チェック
    セキュリティチェック用バッチ  
    スタートアップに関するフォルダ、レジストリ、サービスの差分比較を実行する。  
  - イベントログ取得
    セキュリティチェック用バッチ  
  - ログ収集  
    上記のバッチ実行結果はレポートファイルに格納される。このファイルを一か所に収集する。  
  - 共通部品
    変数の定義、バッチ間での共通処理。



# 機能について

## データバックアップ
  - 使用ファイル
    - backup_SAMPLE.bat 処理の実行。
    - backupMain.bat バックアップのメイン処理。コード値の解析やパスのチェック。
    - backupSub.bat backupMain.batから呼ばれる。robocopyの実行。
    - setenv.bat パスの定義等。
  - 処理内容
    - backup_SAMPLE.bat内に指定したコード値に紐付くバックアップ元先のパスを取得し、robocopyでバックアップ。
    - コード値に紐付くパスはsetenv.batに定義。コード値は複数定義可、またbackup_SAMPLE.batのようなファイルを複数作成可。
    - 実行結果をレポートファイルへ出力する。

## ブラウザキャッシュチェック
  - 使用ファイル
    - checkBrowserCache.bat 処理の実行。
    - comAlarm.bat 異常時のアラーム通知。
    - setenv.bat パスの定義等。
  - 処理内容
    - ブラウザキャッシュ内の危険なキーワードを検索する。
    - エラー時、異常検出時はcomAlarm.batでアラーム通知する。
    - 実行結果をレポートファイルへ出力する。

## スタートアップ改竄チェック
  - 使用ファイル
    - checkStartup.bat 処理の実行。
    - startupListMaster.txt スタートアップ情報を格納したマスタファイル。
    - comAlarm.bat 異常時のアラーム通知。
    - setenv.bat パスの定義等。
  - 処理内容
    - スタートアップ関連フォルダ配下のファイル、レジストリ値、サービスの一覧をファイルに出力。  
      そのファイルとstartupListMaster.txtを差分比較し、差分がある場合は異常と判定する。
    - エラー時、異常検出時はcomAlarm.batでアラーム通知する。
    - 実行結果をレポートファイルへ出力する。

## イベントログ取得
  - 使用ファイル
    - getEventLog.bat 処理の実行。
    - nnnmu24-local-eventlog.jar イベントを解析するjarファイル。
    - comAlarm.bat 異常時のアラーム通知。
    - setenv.bat パスの定義等。
  - 処理内容
    - wevtutilコマンドでシステム、セキュリティ、WindowsDefenderのイベントログを収集する。
    - イベントログの解析は複雑な文字列処理を要するため、nnnmu24-local-eventlog.jarで実施する。
    - エラー時、異常検出時はcomAlarm.batでアラーム通知する。
    - 実行結果をレポートファイルへ出力する。

## ログ収集
  - 使用ファイル
    - logDeploy.bat 処理の実行。
    - fileToUtf8.bat 収集したファイルの文字コード変換。
    - setenv.bat パスの定義等。
  - 処理内容
    - 上記のレポートファイルを収集する。



# ガイドライン

## 自環境への適用
以下のファイルを修正してください。
  - setenv.bat のパス定義を自環境に合わせてください。
  - comAlarm.bat はIP Messengerの通知を想定していますが、バッチ内のコマンド変更も可能です。
  - startupListMaster.txt スタートアップ改竄チェックを利用する場合はマスタとする情報を作成要です。
  - backup_SAMPLE.bat 複数ファイル作成し複数のバックアップパターンを実施することが可能です。
  - イベントログ取得を利用する場合はJAVA1.8以上をインストールしてください。

## バッチの自動実行
  - 定刻で実行する場合は、バッチをタスクスケジューラに登録してください。  
    イベントログ取得は管理者権限で実行する必要があります。

## 実行結果のレポート
  - 各バッチが出力するレポートファイルを参照します。
  - 即時通知が必要なセキュリティ関連のバッチは、異常と判断した場合にアラームを通知します。



# アプリケーションについて

## アプリケーション情報
  - OS：Windows（動作確認はWindows10 Home）
  - 使用ツール：IP Messenger
  - 使用言語：Windowsバッチ、PowerShell、JAVA1.8

## 参考、及び使用
  - Windows 10 Home でグループポリシーエディタを使う方法(http://blog.mr384.com/pc/windows/win10homegpedit/)
  - シフトJISのテキストファイルをUTF-8に変換するバッチ(https://www.shegolab.jp/entry/windows-conv-text-utf8)



# バージョン情報
・バージョン1.0.0  
  2020/12/13 新規作成



# Lisence

This project is licensed under the MIT License, see the LICENSE.txt file for details
