#!/bin/bash
# Written by phoen][x <phoenix@gentoo.org>, Sep/21/2002
# Modifications, enhancements or bugs?  Contact games@gentoo.org

[[ -z "${1}" ]] \
	&& FILE="${HOME}/.ut2003/Benchmark/bench.log" \
	|| FILE="${1}"

CURLINE=0

BM_MIN_SCORE=0
BM_MIN_COUNT=0
BM_MAX_SCORE=0
BM_MAX_COUNT=0

FB_MIN_SCORE=0
FB_MIN_COUNT=0
FB_MAX_SCORE=0
FB_MAX_COUNT=0

while read LINE ; do
	CURLINE=`expr $CURLINE + 1`
	if [[ ${CURLINE} -eq 1 ]] ; then
		echo ">> Results of the UT2003-demo benchmark"
		echo ">> Created on ${LINE}"
		continue
	fi

	set -- ${LINE}
	TYPE=$(echo $(basename ${1}) | cut -d- -f1)
	DETAIL=${3}
	SCORE=${14}

	case ${TYPE} in
	"botmatch")
		case ${DETAIL} in 
		"MinDetail")
			BM_MIN_SCORE=`echo ${BM_MIN_SCORE} + ${SCORE} | bc`
			BM_MIN_COUNT=`expr ${BM_MIN_COUNT} + 1`
			;;
		"MaxDetail")
			BM_MAX_SCORE=`echo ${BM_MAX_SCORE} + ${SCORE} | bc`
			BM_MAX_COUNT=`expr ${BM_MAX_COUNT} + 1`
			;;
		esac
		;;
	"flyby")
		case ${DETAIL} in 
		"MinDetail")
			FB_MIN_SCORE=`echo ${FB_MIN_SCORE} + ${SCORE} | bc`
			FB_MIN_COUNT=`expr ${FB_MIN_COUNT} + 1`
			;;
		"MaxDetail")
			FB_MAX_SCORE=`echo ${FB_MAX_SCORE} + ${SCORE} | bc`
			FB_MAX_COUNT=`expr ${FB_MAX_COUNT} + 1`
			;;
		esac
		;;
	esac
done < ${FILE}

BM_MIN_AVG=`echo "scale=6; ${BM_MIN_SCORE} / ${BM_MIN_COUNT}" | bc`
BM_MAX_AVG=`echo "scale=6; ${BM_MAX_SCORE} / ${BM_MAX_COUNT}" | bc`
BM_ALL_AVG=`echo "scale=6; (${BM_MIN_SCORE} + ${BM_MAX_SCORE}) / (${BM_MIN_COUNT} + ${BM_MAX_COUNT})" | bc`

FB_MIN_AVG=`echo "scale=6; ${FB_MIN_SCORE} / ${FB_MIN_COUNT}" | bc`
FB_MAX_AVG=`echo "scale=6; ${FB_MAX_SCORE} / ${FB_MAX_COUNT}" | bc`
FB_ALL_AVG=`echo "scale=6; (${FB_MIN_SCORE} + ${FB_MAX_SCORE}) / (${FB_MIN_COUNT} + ${FB_MAX_COUNT})" | bc`

echo "
>> Score for Botmatch
MinDetail: ${BM_MIN_AVG} (${BM_MIN_COUNT} tests)
MaxDetail: ${BM_MAX_AVG} (${BM_MAX_COUNT} tests)
Average  : ${BM_ALL_AVG} (`expr ${BM_MIN_COUNT} + ${BM_MAX_COUNT}` tests)

>> Score for FlyBy
MinDetail: ${FB_MIN_AVG} (${FB_MIN_COUNT} tests)
MaxDetail: ${FB_MAX_AVG} (${FB_MAX_COUNT} tests)
Average  : ${FB_ALL_AVG} (`expr ${FB_MIN_COUNT} + ${FB_MAX_COUNT}` tests)"
