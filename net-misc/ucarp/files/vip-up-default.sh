#! /bin/sh
exec 2> /dev/null

/sbin/ip addr add "$2"/"$3" dev "$1"

# or alternatively:
# /sbin/ifconfig "$1":254 "$2" netmask "$3"
