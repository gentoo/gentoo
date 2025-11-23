#! /bin/sh
exec 2> /dev/null

/bin/ip addr del "$2"/"$3" dev "$1"

# or alternatively:
# /sbin/ifconfig "$1":254 down
