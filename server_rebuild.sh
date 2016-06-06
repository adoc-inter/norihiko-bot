#!/bin/bash
echo "$1をリセットしてるよー。データは消えます。キリッ"

export server_id=`cat /home/orangepi/osc2016/$1_id.txt`

#トークン取得
export token=`curl --include -s -X POST -H "Content-Type: application/json" -d '{
    "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "domain": {
                        "name": "Default"
                    },
                    "name": "interop",
                    "password": "interop"
                }
            }
        },
        "scope": {
            "project": {
                "id": "472c6b5fa6d94405a21134937aa825db"
            }
        }
    }
}' 'http://172.16.3.1:5000/v3/auth/tokens' | grep X-Subject-Token | awk '{print $2}' | tr -d '\r'`


#rebuildServer
curl -s -X POST -H "Content-Type: application/json" -H "X-Auth-Token: $token" -d '{
"rebuild": {"imageRef": "4dd2210b-7f78-43a9-92b5-f7d3d91daea1"}
}' "http://172.16.3.1:8774/v2/472c6b5fa6d94405a21134937aa825db/servers/$server_id/action" > /home/orangepi/osc2016/listRevuild_log.txt

. /home/orangepi/osc2016/reconcile.sh
export server_status=`cat /home/orangepi/osc2016/$1_status.txt`
echo "$1の状態を確認中・・・$server_status"

while [ ${server_status} != "SHUTOFF" ]
do
    . /home/orangepi/osc2016/reconcile.sh
    export server_status=`cat /home/orangepi/osc2016/$1_status.txt`
    echo "$1の状態を確認中・・・$server_status"
done

#startServer
echo "$1の電源を投入"
curl -s -X POST -H "X-Auth-Token: $token" -H "Content-Type: application/json" -d '{
     "os-start": null
}' "http://172.16.3.1:8774/v2/472c6b5fa6d94405a21134937aa825db/servers/$server_id/action"

while [ ${server_status} != "ACTIVE" ]
do
    . /home/orangepi/osc2016/reconcile.sh
    export server_status=`cat /home/orangepi/osc2016/$1_status.txt`
    echo "$1の状態を確認中・・・$server_status"
done

#IPアドレス読み込み
export server_addr=`cat /home/orangepi/osc2016/$1_addr.txt`

echo "サーバが起動したよ。IPアドレスは$server_addrだよー。ログインしてみてネ"

#server名のファイルを作成して、ファイル内に時刻を記載
echo `date +%s` > /home/orangepi/osc2016/$1_start_time.txt

