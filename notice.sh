#!/bin/bash
SLACK_URL='https://slack.com/api/chat.postMessage'
SLACK_TOKEN="$1"
CHANNEL="$2"
SUBJECT="$3"
MESSAGE="$4"
USERNAME='Zabbix'
RECOVERSUB='^RECOVER(Y|ED)?$'

if [[ "$SUBJECT" =~ ${RECOVERSUB} ]]; then
	emoji=':o:'
elif [ "$SUBJECT" == 'OK' ]; then
	emoji=':o:'
elif [ "$SUBJECT" == 'PROBLEM' ]; then
	emoji=':x:'
else
	emoji=':exclamation:'
fi

text="${SUBJECT}: ${MESSAGE}"
payload="{\"channel\": \"${CHANNEL//\"/\\\"}\", \"username\": \"${USERNAME//\"/\\\"}\", \"text\": \"${text//\"/\\\"}\", \"icon_emoji\": \"${emoji}\"}"
curl -H 'Content-Type:application/json' -H "Authorization:Bearer ${SLACK_TOKEN}" -d "${payload}" $SLACK_URL
