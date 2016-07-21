#! /bin/bash

logfile=$1
callid=$2

function usage()
{
	echo "USAGE: $1 logfile Call-ID [Call-ID ...]"
	exit -1
}

[ -r "${logfile}" ] || usage $0
[ -n "${callid}" ] || usage $0

shift; shift;
while [ $# -gt 0 ]; do
	callid="${callid}|$1"
	shift
done

dos2unix < "${logfile}" | grep -P '^.*\n<--- (SIP read|(Reliably )?(Ret|T)ransmitting) .*\n([^<\n].*\n)*Call-ID: ('"${callid//./\\.}"')\n((|[^<\n].*)\n)*<-+>$|^.* chan_sip.c: (Reliably )?(Ret|T)ransmitting .*\n([^-\n].*\n)*Call-ID: ('"${callid//./\\.}"')\n((|[^-\n].*)\n)*---$'
