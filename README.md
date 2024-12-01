# 概要

汎用webアプリ開発環境です。
html以下にプロジェクトファイルを展開してください。

# 構築

## .env
.env.example を コピーして .env を作成してください。

`WEB_HOST_NAME` hostname。apache ServerNameや、vite HMRの指定先に使用されます。

`WEB_DOCUMENT_ROOT` apache の DocumentRoot。

`USERNAM, GROUPNAME, UID, GID` apacheがこのユーザーで実行されるようになります。コンテナ外のユーザーと合わせることで、volume内のソース管理などにかかわる権限がスムーズに行きます。

`WP_DBNAME, WP_USERNAME, WP_PASSWORD` WordPressをスクリプトで構築する場合に使用されます。


## 証明書ファイルの設置
./myca 直下に、以下のファイルを設置してください。
nginxコンテナで注入されます。
```
ssl.srt
ssl.key
```

# コマンド

## 起動
```
bash up.sh
```

## 終了
```
bash down.sh
```

## コンテナ内部で実行
```
docker-compose exec web gosu $(id -u):$(id -g) ...
```

# スクリプト

## WordPress構築

```
docker-compose exec web gosu $(id -u):$(id -g) bash /scripts/wp/wpsetup.sh
```


# 証明書の作成

いわゆるオレオレ証明書を作る。

## 証明書の作成

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
使いまわしできるようにワイルドカードでサブドメイン対応もする。
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
