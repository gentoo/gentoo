#!/bin/sh
# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# GVM cron script that updates feed.

# Start to update FEED & First NVT.
try=0
until [ $try -ge 5 ]; do
      greenbone-nvt-sync --curl &>/dev/null && break
      try=$[$try+1]
      sleep 30
done

# Check status
if [ $? -eq 0 ]; then
   # Avoid your IP temporary banned because of multiple connection
   sleep 5
   # Try to update scapdata.
   try=0
   until [ $try -ge 5 ]; do
         greenbone-scapdata-sync &>/dev/null && break
         try=$[$try+1]
         sleep 30
   done

   # Check status
   if [ $? -eq 0 ]; then
      # Avoid your IP temporary banned because of multiple connection
      sleep 5
      # Try to update certdata
      try=0
      until [ $try -ge 5 ]; do
            greenbone-certdata-sync &>/dev/null && break
            try=$[$try+1]
            sleep 30
      done

       # Check status
       if [ $? -eq 0 ]; then
          exit 0
          else
             exit 1
       fi
   fi
fi
