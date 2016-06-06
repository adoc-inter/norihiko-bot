#!/bin/bash

#reconcile処理
. /home/orangepi/osc2016/reconcile.sh

#!/bin/bash
#server選択
export server01_status=`cat /home/orangepi/osc2016/server01_status.txt`
export server02_status=`cat /home/orangepi/osc2016/server02_status.txt`
export server03_status=`cat /home/orangepi/osc2016/server03_status.txt`
export server04_status=`cat /home/orangepi/osc2016/server04_status.txt`

if [ ${server01_status} = "SHUTOFF" ]; then
  /home/orangepi/osc2016/server_rebuild.sh server01
elif [ ${server02_status} = "SHUTOFF" ]; then
  /home/orangepi/osc2016/server_rebuild.sh server02
elif [ ${server03_status} = "SHUTOFF" ]; then
  /home/orangepi/osc2016/server_rebuild.sh server03
elif [ ${server04_status} = "SHUTOFF" ]; then
  /home/orangepi/osc2016/server_rebuild.sh server04
else
 echo "ごめんよー。今サーバはいっぱいみたいなんだ。"
fi

