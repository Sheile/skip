Feature: ユーザの初期プロフィール登録処理
  ユーザは初期登録時、利用規約画面を表示し確認後、プロフィール情報を入力することで利用開始ができる

  Background:
    Given 言語は"ja-JP"
    And   プロフィール項目が登録されていない

  Scenario: 初期登録URLからユーザのプロフィール登録を行なう
    Given 以下の利用開始前のユーザを登録する:
          |login_id|email|name|
          |new001|new001@test.com|新規 一郎|

    When  登録した"1"人目のユーザの新規登録URLにアクセスする
    Then  "利用規約"と表示されていること

    When  "上記内容に同意する"ボタンをクリックする
    Then  "利用者のプロフィール情報の登録"と表示されていること

    When  "ユーザ名"に""と入力する
    And   "ユーザ登録"ボタンをクリックする
    Then  "ユーザ名は4文字以上で入力してください"と表示されていること

    When  "ユーザ名"に"newnew001"と入力する
    And   "パスワード"に"Password1"と入力する
    And   "確認パスワード"に"Password1"と入力する

    And   "ユーザ登録"ボタンをクリックする
    Then  "ようこそ"と表示されること

  Scenario: 初期登録URLからアクセスし利用規約に同意しない
    Given 以下の利用開始前のユーザを登録する:
          |login_id|email|name|
          |new001|new001@test.com|新規 一郎|

    When  登録した"1"人目のユーザの新規登録URLにアクセスする
    Then  "利用規約"と表示されていること

    When  "同意しない"ボタンをクリックする
    Then  "ログイン"と表示されていること