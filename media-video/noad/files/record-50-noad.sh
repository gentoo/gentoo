# $Id$
#
# Joerg Bornkessel <hd_brummy@gentoo.org>
# Mathias Schwarzott <zzam@gentoo.org>
#

. /etc/conf.d/vdraddon.noad

CMD="/usr/bin/noad"

# Parameter to start NoAd
# parameter are "no | yes"

FORCE_OFFLINE_SCAN=no

if [ "${VDR_RECORD_STATE}" = "reccmd" ]; then
	# script started from reccmd
	FORCE_OFFLINE_SCAN=yes
	VDR_RECORD_STATE=after
fi


if [ "${FORCE_OFFLINE_SCAN}" != "yes" ]; then
	# allow it to abort on certain conditions

	# automatic noad scan disabled
	[ "${VDR_USE_NOAD}" = "yes" ] || return

	# ptsmarks existing
	if [ "${NOAD_ONLY_SCAN_IF_NO_PTSMARKS}" = "yes" ]; then
		[ -f "${VDR_RECORD_NAME}/ptsmarks.vdr" ] && return
	fi

	# marks existing
	if [ "${NOAD_ONLY_SCAN_IF_NO_MARKS}" = "yes" ]; then
		[ -f "${VDR_RECORD_NAME}/marks.vdr" ] && return
	fi

	# Add Online-scanning parameter
	case "${NOAD_ONLINE}" in
		live|yes)
			CMD="${CMD} --online=1"
			;;
		all)
			CMD="${CMD} --online=2"
			;;
		no)
			# abort stage "before" here
			[ "${VDR_RECORD_STATE}" = "before" ] && return
			;;
	esac
fi

[ "${NOAD_AC3}" = "yes" ] && CMD="${CMD} -a"
[ "${NOAD_JUMP}" = "yes" ] && CMD="${CMD} -j"
[ "${NOAD_OVERLAP}" = "yes" ] && CMD="${CMD} -o"
[ "${NOAD_MESSAGES}" = "yes" ] && CMD="${CMD} -O"

: ${NOAD_NICE_LEVEL:=18}
if [ "${NOAD_NICE_LEVEL}" != "no" ]; then
	NOAD_NICE_LEVEL=$(($NOAD_NICE_LEVEL+0))
	CMD="nice -n ${NOAD_NICE_LEVEL} ${CMD}"
fi

CMD="${CMD} ${NOAD_PARAMETER}"
${CMD} "${VDR_RECORD_STATE}" "${VDR_RECORD_NAME}" 

