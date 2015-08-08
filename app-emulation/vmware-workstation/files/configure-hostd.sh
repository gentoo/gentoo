#!/bin/bash

action="$1"

case $action in
  add)
    rc-update -q add vmware-workstation-server default
    rc-service vmware-workstation-server start
    ;;
  remove)
    rc-update -q del vmware-workstation-server default
    rc-service vmware-workstation-server stop
    ;;
  status)
    rc-service -q vmware-workstation-server status
    ;;
  *)
    exit 1
    ;;
esac
