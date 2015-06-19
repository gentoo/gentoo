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

#echo "Finding calls from '${anum}' to '${bnum}' in ${logfile}."

# modes:
# 0 - not processing an INVITE.
# 1 - processing an INVITE.
# 2 - from matched (processing).
dos2unix < "${logfile}" | awk '
	BEGIN { mode = 0 }
	mode==0 && $4~"^VERBOSE" {
		dt=$1" "$2" "$3
	}

	mode==0 && $1=="INVITE" && $2 ~ "^sip:'"${bnum}"'@" {
		#print

		mode=1

		split($2, a, "[:@]")
		bnum=a[2]
	}

	mode==1 && $1=="From:" {
		#print
		if ($3 ~ "^<sip:'"${anum}"'@.*>") {
			mode=2
			split($3, a, "[:@]")
			anum=a[2]
		} else {
			#print "From does not match ... leaving block."
			mode = 0
		}
	}

	mode!=0 && $1=="Call-ID:" {
		callid=$2

		if (NF!=2) {
			print "WTF @ Call-ID header having NF!=2"
		}
	}

	mode==1 && $0=="" {
		#print "Leaving block (no match)"
		mode = 0
	}

	mode==2 && $0=="" {
		#print "Leaving block (match)"
		print dt " " anum " " bnum " " callid
		mode = 0
	}
'
