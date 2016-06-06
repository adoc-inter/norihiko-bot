#!/bin/bash

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

#listServersDetailsを実行
curl -s -X GET -H "X-Auth-Token: $token" "http://172.16.3.1:8774/v2/472c6b5fa6d94405a21134937aa825db/servers/detail"  > /home/orangepi/osc2016/listServersDetails.txt

#serverのuuidを取得
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server01")) | .[].id' > /home/orangepi/osc2016/server01_id.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server02")) | .[].id' > /home/orangepi/osc2016/server02_id.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server03")) | .[].id' > /home/orangepi/osc2016/server03_id.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server04")) | .[].id' > /home/orangepi/osc2016/server04_id.txt

#serverのstatusを取得
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server01")) | .[].status' > /home/orangepi/osc2016/server01_status.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server02")) | .[].status' > /home/orangepi/osc2016/server02_status.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server03")) | .[].status' > /home/orangepi/osc2016/server03_status.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server04")) | .[].status' > /home/orangepi/osc2016/server04_status.txt

#serverのフローティングIPアドレスを取得
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server01")) | .[].addresses.internal_net | map(select(."OS-EXT-IPS:type" == "floating")) | .[].addr' > /home/orangepi/osc2016/server01_addr.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server02")) | .[].addresses.internal_net | map(select(."OS-EXT-IPS:type" == "floating")) | .[].addr' > /home/orangepi/osc2016/server02_addr.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server03")) | .[].addresses.internal_net | map(select(."OS-EXT-IPS:type" == "floating")) | .[].addr' > /home/orangepi/osc2016/server03_addr.txt
cat /home/orangepi/osc2016/listServersDetails.txt | jq -r '.servers | map(select(.name == "server04")) | .[].addresses.internal_net | map(select(."OS-EXT-IPS:type" == "floating")) | .[].addr' > /home/orangepi/osc2016/server04_addr.txt
