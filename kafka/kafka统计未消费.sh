
#kafka 统计未消费 发送通告
#!/bin/bash

while true
do

KAFKA_GROUP_COMMAND="kafka-consumer-groups.sh --bootstrap-server 127.0.0.1:9092"

result=$($KAFKA_GROUP_COMMAND  --describe --group kafka_otc | tail -80 | awk '{print $5}')

eval $(echo $result | awk '{split($0, a, " ");for(i in a) print "KAFKA_GROUP_ARRAY["i"]="a[i]}')

len=${#KAFKA_GROUP_ARRAY[*]}

i=0
number=0
while [ $i -lt $len ]
do
  ((i++))

if grep '^[[:digit:]]*$' <<< "${KAFKA_GROUP_ARRAY[$i]}";then
   # echo "${KAFKA_GROUP_ARRAY[$i]} is number."
 number=`expr ${KAFKA_GROUP_ARRAY[$i]} + $number`

else
    echo  'no numbers!!!'
fi
#  number=`expr ${KAFKA_GROUP_ARRAY[$i]} + $number`
 # if [ $number -gt 3000 ]
 # then
 #   TIME=;date
 # MS="${TIME} lags of kafka group is ${number} now, please check its status"
 #   echo $number": lag is great than 3000"
    # T1EPB6406/B1EPT4KA9/6a5uzgk2yNNMDBO7ghnnbEuH
   # curl -X POST --data-urlencode 'payload={"channel": "wc_test_server", "username": "bot", "text":"'"${MS}"'"}' https://hooks.slack.com/services/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
   # break

 # fi
done



if [ $number -gt 3000 ]
  then
    TIME=;date
  MS="${TIME} lags of kafka group is ${number} now, please check its status"
    echo $number": lag is great than 3000"

  curl -X POST --data-urlencode 'payload={"channel": "wc_test_server", "username": "bot", "text":"'"${MS}"'"}' https://hooks.slack.com/services/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
   # break

  fi

TIMES=;date
echo "${TIMES} now the total of lags is" $number
sleep 100
done