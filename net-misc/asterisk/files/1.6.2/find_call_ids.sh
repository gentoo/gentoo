#! /bin/bash

logfile=$1
anum=$2
bnum=$3

function usage()
{
	echo "USAGE: $1 logfile anum bnum"
	exit -1
}

[ -r "${logfile}" ] || usage $0
[ -n "${anum}" ] || usage $0
[ -n "${bnum}" ] || usage $0

grep -B2 -P '^INVITE sip:'"${bnum}"'@.*\n(([^F].*|F[^r].*|Fr[^o].*|Fro[^m].*|From[^:]|From:.*<sip:'"${anum}"'@.*>.*)\r\n)+\r\n' "${logfile}" | awk '$4 ~ "^VERBOSE" { dt=$1" "$2" "$3 } $1=="Call-ID:" { if (cid != $2) { cid=$2; print dt" "cid; }}'
