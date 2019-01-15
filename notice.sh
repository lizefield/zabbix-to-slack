#!/bin/bash
SLACK_URL='https://slack.com/api/chat.postMessage'
SLACK_TOKEN="$1"
CHANNEL="$2"
SUBJECT="$3"
MESSAGE="$4"
USERNAME='Zabbix'
RECOVERSUB='^RECOVER(Y|ED)?$'

if [[ "$SUBJECT" =~ ${RECOVERSUB} ]]; then
	EMOJI=':o:'
  COLOR='good'
elif [ "$SUBJECT" == 'OK' ]; then
	EMOJI=':o:'
  COLOR='good'
elif [ "$SUBJECT" == 'PROBLEM' ]; then
	EMOJI=':x:'
  COLOR='danger'
else
	EMOJI=':exclamation:'
  COLOR='#439FE0'
fi

text="${SUBJECT}: ${MESSAGE}"
payload="{
    \"channel\": \"${CHANNEL//\"/\\\"}\",
    \"username\": \"${USERNAME//\"/\\\"}\",
    \"icon_emoji\": \"${EMOJI}\",
    \"attachments\": [{
      \"color\": \"${COLOR}\",
      \"text\": \"${text//\"/\\\"}\"
    }]
  }"
curl -H 'Content-Type:application/json' -H "Authorization:Bearer ${SLACK_TOKEN}" -d "${payload}" $SLACK_URL
