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

# modes:
# 0 - searching for SIP start block ...
# 1 - transmit of sorts
# 2 - receive

dos2unix < "${logfile}" | awk '
	BEGIN { mode = 0 }
	mode==0 && $4~"^VERBOSE" {
		dt=$1" "$2" "$3
	}

	mode!=0 && $1 == "Call-ID:" {
		#print

		if ($2 ~ /('"${callid}"')/) {
			callidmatch=1
		} else {
			#print $2" does not match ^('"${callid}"')$"
			mode=0
		}
	}

	(mode==1 && $0=="---") || (mode==2 && $0=="<------------->") {
		if (callidmatch) {
			print dt" "sipmode"\n"pckt"---"
		}

		mode=0
	}

	mode!=0 {
		pckt = pckt $0 "\n"
	}

	mode==0 && $0 ~ "chan_sip[.]c: .*[tT]ransmitting" {
		#print

		if ($6 == "Retransmitting") {
			sipmode = $6" "$7" to "$NF
		} else {
			sipmode = "Transmitting to "$NF
		}

		mode=1
		pckt=""
		callidmatch=0
	}

	mode==0 && $0 ~ "SIP read from" {
		#print
		mode=2
		pckt=""
		callidmatch=0
		sipmode="Received from "$5":"
	}
'
