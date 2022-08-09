# 概要

汎用web環境docker-composeです。
html以下にプロジェクトファイルを展開してください。

# 構築の手順

## clone
```
git clone https://github.com/ephabe/web.git project_name
```

## 起動前
php/dockerfile を必要なphp環境に合わせて書き換えてください。
また、docker-compose.example.ymlをコピーしてdocker-compose.ymlを作成し、UIDやGIDの内容、およびDBのrootパスワードを設定してください。

## 初回起動
```
docker-compose up -d
```

## dockerイメージからconfをコピーしてくる
```
docker cp `docker-compose ps -q web`:/etc/apache2/sites-available/000-default.conf ./php/conf/000-default.conf
docker cp `docker-compose ps -q web`:/etc/apache2/mods-available/ssl.conf ./php/conf/ssl.conf
docker cp `docker-compose ps -q web`:/etc/ssl/openssl.cnf ./php/ssl/openssl.cnf
```

## 証明書の作成
既にある場合は myca 直下に証明書ファイルを配置してスキップ。

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

## 一旦終了
```
docker-compose down
```

## confを書き換え
000-default.conf
```
NameVirtualHost *:80
Listen 3000

<VirtualHost *:80>
  ServerName localhost
  DocumentRoot /var/www/html
  <Directory /var/www/html>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>

<VirtualHost *:80>
  ServerName dev.internal
  DocumentRoot /var/www/html/public
</VirtualHost>

<VirtualHost *:443>
  ServerName dev.internal
  DocumentRoot /var/www/html/public
</VirtualHost>
```

ssl.conf
追記。必要に応じて書き換え
ファイル末尾 &lt;/IfModule&gt; 直前
```
SSLCertificateFile /etc/ssl/myca/ssl.crt
SSLCertificateKeyFile /etc/ssl/myca/ssl.key
```

openssl.cnf
追記。必要に応じて書き換え
```
[ alt_names ]
DNS.1 = dev.internal
DNS.2 = *.dev.internal
```

## 証明書をホスト側にインストール
既にインストール済ならスキップ。
myca直下に作成されたcrtファイルをホストにインストールする。

## docker-compose.ymlのコメントアウトを外す
```
- ./php/php.ini:/usr/local/etc/php/php.ini
- ./php/conf/000-default.conf:/etc/apache2/sites-available/000-default.conf
- ./php/conf/ssl.conf:/etc/apache2/mods-available/ssl.conf
- ./php/ssl/openssl.cnf:/etc/ssl/openssl.cnf
```

## 再起動
```
docker-compose up -d
```

# その他コマンド

## ユーザーを指定して実行
```
docker-compose exec web gosu 1002:1002 ~
```

## dockerイメージをキャッシュを使用せずに再ビルド
```
docker-compose build --no-cache
```