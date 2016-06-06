#!/bin/bash
echo "$1の電源を落とすよー"

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

#stopServer
curl -s -X POST -H "X-Auth-Token: $token" -H "Content-Type: application/json" -d '{
     "os-stop": null
}' "http://172.16.3.1:8774/v2/472c6b5fa6d94405a21134937aa825db/servers/$server_id/action"




#起動時間計算
start_time=`cat /home/orangepi/osc2016/$1_start_time.txt`
end_time=`date +%s`
PT=$((end_time - start_time))

H=`expr ${PT} / 3600`
PT=`expr ${PT} % 3600`
M=`expr ${PT} / 60`
S=`expr ${PT} % 60`

echo "${H}時間${M}分${S}秒くらいお勉強したね！。またやろうね。"

