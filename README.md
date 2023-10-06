# 概要

汎用web環境docker-composeです。
html以下にプロジェクトファイルを展開してください。

# 構築の手順

## clone
```
git clone https://github.com/ephabe/webcontainer.git project_name
```

## 起動前に

### .env
.env.exampleをコピーして.envを作成してください。

`WEB_HOST_NAME` アクセスするhostname。ホスト（ブラウザ）側のhostsの記述と合わせせておくと良いです。

`WEB_DOCUMENT_ROOT` webコンテナ内のwebroot path。

`WEB_HTTP_PORT, WEB_HTTPS_PORT` アクセスする時port

`USERNAM, GROUPNAME, UID, GID` このユーザーを作成したあと、apacheがこのユーザーで実行されるようになります。ホスト（エディタやgit）のユーザーと合わせることで、volume内のソース管理などにかかわる権限がスムーズに行きます。


### 証明書ファイルの設置
./myca 直下に、以下のファイルを設置してください。
（ssl.conf 末尾に記述）
```
ssl.srt
ssl.key
```

証明書ファイルを作成できない場合はSSL関連ファイルのvolomesの記述をコメントアウトしてください（次項）。

### SSLが不要な場合
SSL化不要の場合は docker-compose.yml 内、webコンテナのvolumeesの記述で、以下の行をコメントアウトしてください。
```
      # - ./apache/ssl.conf:/etc/apache2/mods-available/ssl.conf
      # - ./myca:/etc/ssl/myca
```

## 起動
```
bash up.sh
```

## 終了
```
bash down.sh
```


# 証明書の作成

いわゆるオレオレ証明書を作る。

## 証明書の作成

備考。

コンテナに入る
```
docker container exec -it web bash
```

mycaディレクトリに移動
```
cd /etc/ssl/myca
```

ssl.key, ssl.csr 作成
```
openssl genrsa -out ssl.key 2048
openssl req -new -sha256 -key ssl.key -out ssl.csr
```

ssl.txt 作成

ワイルドカードで作成することで次回以降はファイルをコピーしてくるだけで使える。
```
echo "subjectAltName = DNS:dev.internal, DNS:*.dev.internal" > san.txt
```
DNSは必要に応じて書き換え

ssl.txt 作成
```
echo "subjectAltName = DNS:dev.internal, DNS:*.dev.internal" > san.txt
```

ssl.crt 作成
```
openssl x509 -req -sha256 -days 365 -signkey ssl.key -in ssl.csr -out ssl.crt -extfile san.txt
```

証明書の中身を確認
```
openssl x509 -in ssl.crt -text -noout
```

## 証明書をホスト側にインストール
myca直下に作成されたcrtファイルをホストにインストールする。

# WPセットアップ
```
docker-compose exec web gosu $(id -u):$(id -g) bash /scripts/wp/wpsetup.sh
```

# その他コマンド

## ユーザーを指定して実行
```
docker-compose exec web gosu $(id -u):$(id -g) ~~
```

## dockerイメージをキャッシュを使用せずに再ビルド
```
docker-compose build --no-cache
```

# 課題
- pgsql対応
- フロントの汎用開発環境を持ってくる