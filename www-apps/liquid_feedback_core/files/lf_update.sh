#!/bin/bash

while true; do
  nice /usr/bin/lf_update dbname=$1
  nice /usr/bin/lf_update_issue_order dbname=$1
  nice /usr/bin/lf_update_suggestion_order dbname=$1
  sleep 5m
done
