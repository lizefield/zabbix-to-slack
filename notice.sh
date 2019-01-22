#!/bin/bash
ZABBIX_URL='http://18.182.183.219/zabbix/'
SLACK_URL='https://slack.com/api/chat.postMessage'
SLACK_TOKEN="$1"
CHANNEL="$2"
SUBJECT="$3"
MESSAGE="$4"
USERNAME='Zabbix'
RECOVERSUB='^RECOVER(Y|ED)?$'

if [[ "${MESSAGE}" == *'Normal "Generic"'* ]]; then
  COLOR="#91bbfc"
elif [ "${SUBJECT%%:*}" == 'OK' ]; then
  COLOR="good"
elif [ "${SUBJECT%%:*}" == 'Resolved' ]; then
  COLOR="good"
elif [ "${SUBJECT%%:*}" == 'Problem' ]; then
  COLOR="danger"
else
  COLOR="#808080"
fi

MESSAGE=`echo ${MESSAGE} | sed -e 's/"//g'`
PAYLOAD="{
    \"channel\": \"${CHANNEL//\"/\\\"}\",
    \"username\": \"${USERNAME//\"/\\\"}\",
    \"attachments\": [{
      \"fallback\": \"${SUBJECT}\",
      \"text\": \"${ZABBIX_URL}\",
      \"color\": \"${COLOR}\",
      \"fields\":[
        {
          \"title\": \"${SUBJECT%%:*}\",
          \"value\": \"${MESSAGE}\",
          \"short\": true
        }
      ]
    }]
  }"
curl -H 'Content-Type:application/json' -H "Authorization:Bearer ${SLACK_TOKEN}" -d "${PAYLOAD}" $SLACK_URL
