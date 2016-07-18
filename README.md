# Installation

## docker-composerをインストール
````
$ sudo su
$ curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
$ exit
````

## 作業用のディレクトリを作成

````
mkdir workdir && cd workdir
````

## docker-compose.ymlをコピー
````
$ wget https://raw.githubusercontent.com/kirikak2/ajax_sample/master/examples/docker-compose.yml
````

## docker-composeを起動
````
sudo /usr/local/bin/docker-compose up -d
````

## dockerコンテナに入り、データベースの作成とテーブル作成を行う
````
$ sudo /usr/local/bin/docker-compose exec web bash
$ RAILS_ENV=production bundle exec rake db:create
$ RAILS_ENV=production bundle exec rake db:migrate
$ exit
````

## データファイルをダウンロードし、mysqlにインポートする

````
$ wget https://raw.githubusercontent.com/kirikak2/ajax_sample/master/db/personal_infomation_500.csv
$ mysql -u root -p -h 127.0.0.1 ajax_sample_production
Enter password: (mysqlのパスワードはpassword)
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 4
Server version: 5.7.13 MySQL Community Server (GPL)

Copyright (c) 2000, 2015, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> load data local infile "/tmp/personal_infomation_500.csv" into table addresses fields terminated by ',';
Query OK, 500 rows affected, 6500 warnings (0.02 sec)
Records: 500  Deleted: 0  Skipped: 0  Warnings: 6500

mysql> exit
Bye
````

## 外部からURLを呼び出し、正しく応答が返ることを確認する
````
wget http://サーバのIPアドレス:バインドしたポート番号（例:3000)/addresses.json

(JSONが取得できる)
````

# Ajax Sample Specification

## データ構造

|項目名|意味|
|-------|-------|
|name|名前|
|name_kana|名前のカナ表記|
|gender|性別|
|phone|携帯電話番号|
|mail|メールアドレス|
|zipcode|郵便番号|
|address1|住所1（県名）|
|address2|住所2（市町村）|
|address3|住所3（地名）|
|address4|住所4（番地）|
|address5|住所5（その他）|
|age|年齢|

## API

### 一覧の取得
````
GET /addresses.json
````
#### Arguments

|パラメータ名|意味|呼び出し例|
|------------|----|----------|
|columns|表示するカラムを呼び出す、カンマ区切りで複数指定|/addresses.json?columns=name,age|
|per|１ページあたりの表示件数|/addresses.json?per=10|
|page|ページ指定（perを指定した時のみ有効）1から開始|/addresses.json?per=10&page=2|
|name|検索条件（部分一致）|/addresses.json?name=xxx|
|name_kana|検索条件（部分一致）|/addresses.json?name_kana=xxx|
|email|検索条件（部分一致）|/addresses.json?email=xxx|
|address1|検索条件（部分一致）|/addresses.json?address1=xxx|
|age|検索条件（完全一致）|/addresses.json?age=xx|
|mode|検索条件を複数指定した時に、or条件で結合するか、and条件で結合するかを指定、デフォルトはand|/addresses.json?name=xxx&email=yyy&mode=or|

#### レスポンス
````
{
  "total": 500,
  "per": 500,
  "page": 1,
  "results": [
    {"id": 1, "name": "name", "name_kana": "name_kana"},
    ...
  ]
}
````

----

### データの作成
````
POST /addresses.json
````

#### リクエストボディ
````
data={"name":"xxxx","name_kana":"yyyy","gender":"zz","phone":"080-xxxx-xxxx","mail":"xxxx@xxxx.xxxx","zipcode":"xxx-xxxx","address1":"xxx","address2":"xxxx","address3":"xxx","address4":"x-x","address5":"","age":xxx}
````

#### レスポンス
````
{"id":1,"name":"xxxx","name_kana":"yyyy","gender":"zz","phone":"080-xxxx-xxxx","mail":"xxxx@xxxx.xxxx","zipcode":"xxx-xxxx","address1":"xxx","address2":"xxxx","address3":"xxx","address4":"x-x","address5":"","age":xxx}
````
----
### データの更新
````
PATCH /addresses/[:id].json
PUT /addresses/[:id].json
````

#### リクエストボディ
````
data={"age":xxx}
````

#### レスポンス
````
{"id":1,"name":"xxxx","name_kana":"yyyy","gender":"zz","phone":"080-xxxx-xxxx","mail":"xxxx@xxxx.xxxx","zipcode":"xxx-xxxx","address1":"xxx","address2":"xxxx","address3":"xxx","address4":"x-x","address5":"","age":xxx}
````
----
### データの削除
````
DELETE /addresses/[:id].json
````

#### レスポンス

ステータスコードのみ。レスポンスは返しません。

# Development

````
git clone https://github.com/kirikak2/ajax_sample.git
cd ajax_sample
sudo docker-compose up -d
````

ルートのdocker-compose.ymlを使用すると、Railsサーバがdevelopmentモードで立ち上がります。
