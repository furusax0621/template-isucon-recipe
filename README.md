# ISUCON をなるべく快適に戦うためのテンプレート環境

ISUCON を戦う上で役に立つツールのセットアップを支援するリポジトリです。

## このリポジトリでできること

### pprotein 用サーバーの構築

pprotein をインストールするためのEC2インスタンスを起動することができます。
pprotein 用サーバーは競技用環境とは独立して作成されるため、ISUCON競技開始前にセットアップし、準備しておくことが可能です。

### 競技用サーバーへの pprotein エージェントのインストール

競技用サーバーで pprotein による情報収集を可能にするためのセットアップを支援します。
具体的には以下をインストールすることができます。

- アクセスログを alp 対応フォーマットに設定するNginxの設定ファイル( `/etc/nginx/conf.d/alp.conf` )
- スロークエリログを有効化するMySQLサーバーの設定ファイル ( `/etc/mysql/mysql.conf.d/slow-query-log.cnf` )
- pprotein エージェントサービス

また、競技用アプリケーションや pprotein-agent が各種ログを読み取れるよう、ログファイルやディレクトリのパーミッションを `777` に変更します。

## 使い方

### 1. CloudFormation テンプレートのパラメータ調整

ご自身の作業環境にあわせて `cloudformation/parameters.json` の内容を修正してください。
デフォルトでは[furusax0621](https://github.com/furusax0621)の公開鍵をEC2インスタンスにインストールし、
任意のIPアドレスからのHTTPリクエストを許可する設定になっています。

> [!IMPORTANT]
> 特にIPアドレスはご自宅のインターネット回線のグローバルIPアドレスにするなど、必ず修正をしてください。

例えば、HTTPアクセスを `11.22.33.44` というIPアドレスに限定したい場合、次のように修正してください。

```json
[
    "AllowIp=11.22.33.44/32",
    "GitHubName=furusax0621"
]
```

### 2. CloudFormation テンプレートのデプロイ

次のようにコマンドを実行し、CloudFormation テンプレートをデプロイしてください。
実行にはAWS CLI v2が必要です。

```shell
cd cloudformation
make deploy
```

デプロイが成功すると、次のリソースが作成されます。

- VPC
- インターネットゲートウェイ
- サブネット
- HTTP接続を許可するためのセキュリティグループ
- Session Managerで接続するためのIAMロール
- EC2インスタンス
- Elastic IPアドレス

### 3. pprotein サーバーの起動

EC2インスタンスの起動に成功すると、Session Managerを介してSSH接続できるようになります。
ec2-user に対し、1.で指定したGitHubアカウントの公開鍵がインストールされています。

```shell
ssh ec2-user@<InstanceId>
```

Session ManagerでSSH接続するためのセットアップは[公式ドキュメント](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-enable-ssh-connections.html)を参照してください。

SSH接続後、このリポジトリをクローンした上でモニター用のインストールスクリプトを実行してください。

```shell
git clone git@github.com:furusax0621/template-isucon-recipe.git ./recipe
cd recipe
./install-monitor.sh
```

インストールが完了すると、 `http://<ElasticIp>` で pprotein サーバーにアクセスすることができます。

### 4. 競技用サーバーのセットアップ

競技用サーバーにSSH接続し、インストールスクリプトを実行してください。

```shell
git clone git@github.com:furusax0621/template-isucon-recipe.git ./recipe
cd recipe
./install-app.sh
```

競技用のアプリケーションに pprotein を統合することを考慮し、デフォルトで pprotein-agent サービスは無効化されています。
MySQLサーバーを独立させる場合など、pprotein-agent を起動したい場合は次のように実行してください。

```shell
sudo systemctl enable pprotein-agent
sudo systemctl start pprotein-agent
```

### 5. pprotein 用サーバーからのポートフォワーディング

pprotein 用サーバーと競技用サーバーは別VPCで構築されるため、pprotein による情報収集をするためにはSSHポートフォワーディングを利用します。
pprotein 用サーバーから競技用サーバーに対して接続を確立するのがオススメです。

以下は、SSHポートフォワーディングで双方向に通信経路を確立する例です。
この例では競技用サーバーの19000ポートで稼働するpproteinエージェントに対し、pprotein 用サーバーから19001ポートでアクセスすることを想定しています。
また、競技用サーバーは18080ポートにアクセスすることで、pprotein 用サーバーで稼働する pprotein にアクセスすることができます。

```shell
ssh -L 19001:localhost:19000 -R 18080:localhost:80 isucon@<競技用サーバーのIPアドレス>
```
