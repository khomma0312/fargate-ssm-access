# fargate-ssm-access
## 概要
- FargateにAWS SSM Session Managerを通して、SSH接続できるイメージのDockerfile
## 前提
- ベースイメージにはhttpdを使用（イメージのOSはDebian）
- 東京リージョンで各リソースを作成する
## 構築手順
1. AWS Systems Manager > ハイブリッドアクティベーションから、アクティベーションを作成して、Activation IDとActivation Codeを控えておく。また、アクティベーション作成時には、AWSが用意してくれるRoleを使用する。（コンテナ起動の際に、有効期限・インスタンス数の上限を超えていないように注意）
2. Dockerfileをビルドして、ECRにそのイメージをプッシュしておく。
3. SSMパラメータストアに、Activation ID, Activation Codeを設定する。
4. ECS用のRoleを作成する。ポリシーには、AWSが用意してくれるecsTaskExecutionRoleのポリシー + AmazonSSMManagedInstanceCore + SSMパラメータ読み込み用のポリシー（あとで調べて書く）をアタッチする。
5. Fargateを起動するタスク定義を作成する。設定の際には以下の点に注意する。
	- タスクロールには、上で作成したECS用のRoleを設定する。
	- タスク定義のコンテナの設定では、コンテナイメージに上の手順でプッシュしたECRリポジトリを指定する。
	- コンテナの環境変数に、SSMパラメータでアクティベーションコードとIDを指定したパラメータのキーをvalueFromで指定する。（`SSM_AGENT_CODE` にはActivation Code、`SSM_AGENT_ID` にはActivation IDの値が入るように設定する）
6. 起動タイプをFargateにして、作成したタスク定義からタスクを起動する。
7. AWS Systems Manager > セッションマネージャーから、「セッションの開始」をクリックし、対象のインスタンスを選択して、セッションを開始する。
8. 接続ができれば成功！
