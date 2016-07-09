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
|-|-|-|
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
