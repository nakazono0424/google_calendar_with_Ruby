# calmana
+ 動作環境
  + ruby 2.5.1
  + bundle 2.1.4
  + 他のバージョンでは未確認
+ 説明
  + Google Calendar APIのWatchを利用した，Google Calendar上の変更を監視するシステム(の予定)．
  + 現状はGoogleカレンダに対して操作を行なうのみ
  + 予定を登録する際，リカーレンス名をプロパティとして設定することが可能．
  
# Setup
+ Clone code
  ```
  $ git clone git@github.com:nakazono0424/calmana.git
  ```

+ Install gems
  ```
  $ bundle install --path vendor/bundle
  ```
  
+ aouthorize
  ```
  $ bundle exec ruby main.rb
  ```
  この際，Google Calendar API の client_id と client_secret が必要になる．
  + [client_id と，client_secret の入手方法に関するドキュメント](https://developers.google.com/adwords/api/docs/guides/authentication?hl=ja#installed)
  + [Google API console](https://console.developers.google.com)
  
  認証に成功すると，`Aouthorize Success!`と表示される．
  
# Usage
|COMMAND| DESCRIPTION |
|:-|:-|
|bundle exec ruby main.rb calendars|カレンダの一覧を表示する．|
|bundle exec ruby main.rb show_events CALENDAR_ID    |CALENDAR_IDのカレンダ上の予定を表示する．|
|bundle exec ruby main.rb delete CALENDAR_ID EVENT_ID|CALENDAR_IDのカレンダ上にあるEVENT_IDの予定を削除する|
|bundle exec ruby main.rb post_event CALENDAR_ID TITLE START END|CALENDAR_IDのカレンダに予定を追加する．(予定名：TITLE，開始日：START(YYYY-MM)，終了日：END(YYYY-MM)，リカーレンス名：TITLE)|

`post_event`コマンドについては，開始日，終了日に日時を指定するように修正することを検討中．
リカーレンス名の指定は修正予定．

