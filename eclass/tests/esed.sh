#!/usr/bin/env bash
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit esed

cd "${WORKDIR:-/dev/null}" || exit

tsddied=n
tsddie() {
	tsddied=y
	tsddiemsg=${*}
	echo "would die: ${tsddiemsg}" >&2
	# silence some further errors given didn't actually die
	sed() { :; }
	die() { :; }
}

tsdbegin() {
	tbegin "${1}"
	tsddied=n
	unset -f sed
	die() { tsddie "${@}"; }
}

tsdend() {
	if [[ ${1} == fatal* && ${tsddied} == n ]]; then
		tend 127 "should have died"
	elif [[ ${1} == fatal:* && ${tsddied} == y && ${tsddiemsg} != *"${1#fatal:}"* ]]; then
		tend 128 "died as expected but die message does not match '*${1#fatal:}*'"
	elif [[ ${1} == nonfatal && ${tsddied} == y ]]; then
		tend 129 "should not have died"
	else
		tend ${2:-0} "something went wrong(tm)"
	fi
}

tsdfile() {
	local file
	for file in "${@}"; do
		if [[ ${file%:*} ]]; then
			echo "${file%:*}" > "${file#*:}" || exit
		elif [[ -e ${file#*:} ]]; then
			rm -- "${file#*:}" || exit
		fi
	done
}

tsdcmp() {
	local contents
	contents=$(<"${1}") || exit
	if [[ ${contents} != "${2}" ]]; then
		echo "${FUNCNAME[0]}: '${contents}' != '${2}'"
		return 1
	fi
}

tsdbegin "esed: change on single file"
tsdfile replace:file
esed s/replace/new/ file
tsdcmp file new
tsdend nonfatal ${?}

tsdbegin "esed: die due to no change on a single file"
tsdfile keep:file
esed s/replace/new/ file
tsdcmp file keep
tsdend fatal:no-op ${?}

tsdbegin "esed: sequential changes"
tsdfile replace1:file
esed -e s/replace1/replace2/ -e s/replace2/new/ file
tsdcmp file new
tsdend nonfatal ${?}

tsdbegin "esed: change on at least one of two files with ESED_VERBOSE=1"
tsdfile keep:file1 replace:file2
ESED_VERBOSE=1 esed s/replace/new/ file1 file2
tsdcmp file1 keep &&
	tsdcmp file2 new
tsdend nonfatal ${?}

tsdbegin "esed: die due to no change on two files with ESED_VERBOSE=1"
tsdfile keep:file{1..2}
ESED_VERBOSE=1 esed s/replace/new/ file1 file2
tsdcmp file1 keep &&
	tsdcmp file2 keep
tsdend fatal:'no-op' ${?}

tsdbegin "esed: -E/-n/-r arguments"
tsdfile $'hide\nshow\nhide\nthis':file
esed -E -n -r '/(show|this)/p' file
tsdcmp file $'show\nthis'
tsdend nonfatal ${?}

tsdbegin "esed: die due to passing unrecognized -i"
tsdfile replace:file
esed -i s/replace/new/ file
tsdend fatal:'unrecognized option'

tsdbegin "esed: change files with one nicely named '-- -e'"
tsdfile replace:"-- -e" replace:file
esed -e s/replace/new/ file -- "-- -e"
tsdcmp file new &&
	tsdcmp "-- -e" new
tsdend nonfatal ${?}

tsdbegin "esed: die due to no files in arguments"
esed -e s/replace/new/ -e s/replace/new/
tsdend fatal:'no files in'

tsdbegin "esed: die due to missing file"
tsdfile :missing
esed s/replace/new/ missing
tsdend fatal:'missing'

tsdbegin "enewsed: change on a new file"
tsdfile replace:file :newfile
enewsed s/replace/new/ file newfile
tsdcmp file replace &&
	tsdcmp newfile new
tsdend nonfatal ${?}

tsdbegin "enewsed: die due to too many files"
tsdfile replace:file1 replace:file2 :newfile
enewsed s/replace/new/ file1 file2 newfile
tsdend fatal:'exactly one input'

tsdbegin "enewsed: die due to missing output file"
tsdfile keep:file
enewsed -e s/replace/new/ -e s/replace/new/ file
tsdend fatal:'no files in'

tsdbegin "enewsed: die due too few arguments beside files"
tsdfile keep:file
enewsed file newfile
tsdend fatal:'too few arguments'

tsdbegin "erepl: change on a single file"
tsdfile 0000:file
erepl 0 1 file
tsdcmp file 1111
tsdend nonfatal ${?}

tsdbegin "erepl: die due to no change on a single file"
tsdfile keep:file
erepl missing new file
tsdcmp file keep
tsdend fatal:'no-op' ${?}

tsdbegin "erepl: change on at least one of two files with ESED_VERBOSE=1"
tsdfile keep:file1 replace:file2
ESED_VERBOSE=1 erepl replace new file1 file2
tsdcmp file1 keep &&
	tsdcmp file2 new
tsdend nonfatal ${?}

tsdbegin "erepl: die due to no change on two files with ESED_VERBOSE=1"
tsdfile keep:file{1..2}
ESED_VERBOSE=1 erepl replace new file1 file2
tsdcmp file1 keep &&
	tsdcmp file2 keep
tsdend fatal:'no-op' ${?}

tsdbegin "erepl: change containing globs that should be ignored"
tsdfile "*[0-9]{1,2}()":file
erepl "*[0-9]{1,2}()" new file
tsdcmp file new
tsdend nonfatal ${?}

tsdbegin "enewrepl: change on a new file"
tsdfile replace:file :newfile
enewrepl replace new file newfile
tsdcmp file replace &&
	tsdcmp newfile new
tsdend nonfatal ${?}

tsdbegin "enewrepl: die due to too many files"
tsdfile replace:file1 replace:file2 :newfile
enewrepl replace new file1 file2 newfile
tsdend fatal:'exactly one input'

tsdbegin "enewrepl: die due to missing output file"
tsdfile keep:file
enewrepl replace new file
tsdend fatal:'too few arguments'

tsdbegin "erepld: delete matching lines"
tsdfile $'match\nkeep\nmatch':file
erepld ^match file
tsdcmp file keep
tsdend nonfatal ${?}

tsdbegin "enewrepld: delete matching lines"
tsdfile $'match\nkeep\nmatch':file :newfile
enewrepld ^match file newfile
tsdcmp file $'match\nkeep\nmatch' &&
	tsdcmp newfile keep
tsdend nonfatal ${?}

tsdbegin "ereplp: change matching lines"
tsdfile $'match=0000\nkeep=0000\nmatch=0000':file
ereplp ^match 0 1 file
tsdcmp file $'match=1111\nkeep=0000\nmatch=1111'
tsdend nonfatal ${?}

tsdbegin "enewreplp: change matching lines"
tsdfile $'match=0000\nkeep=0000\nmatch=0000':file :newfile
enewreplp ^match 0 1 file newfile
tsdcmp file $'match=0000\nkeep=0000\nmatch=0000' &&
	tsdcmp newfile $'match=1111\nkeep=0000\nmatch=1111'
tsdend nonfatal ${?}

tsdbegin "efind+esed: change found files"
tsdfile keep:file1.find1 replace:file2.find1
efind . -type f -name '*.find1' -erun esed s/replace/new/
tsdcmp file1.find1 keep &&
	tsdcmp file2.find1 new
tsdend nonfatal ${?}

tsdbegin "efind+esed: die due no changes to found files"
tsdfile keep:file1.find2 keep:file2.find2
efind . -type f -name '*.find2' -erun esed s/replace/new/
tsdcmp file1.find2 keep &&
	tsdcmp file2.find2 keep
tsdend fatal:'no-op' ${?}

tsdbegin "efind: die due to bad command"
tsdfile keep:file.find3
efind . -type f -name '*.find3' -erun ./no-such-file
tsdend fatal:'failed: ./no-such-file' ${?}

tsdbegin "efind: don't die for shell functions"
tsdfile keep:*.find4
tsd-test-func() {
	# would die in the function if there was an issue
	echo "${FUNCNAME[*]} running for files: ${*@Q}"
	local i=1
	(( --i )) # uh-oh, this leaves "unintended" failure return value
}
efind . -type f -name '*.find4' -erun tsd-test-func
tsdend nonfatal

tsdbegin "efind: die due to missing -erun"
tsdfile keep:ignore-perm.find5
efind . -type f -name '*.find5'
tsdend fatal:'missing -erun'

tsdbegin "efind: die due to no files found"
efind . -type f -name '*.missing' -erun echo -n
tsdend fatal:'no files from'

echo
echo "note: any error messages after 'would die:' can be ignored"
if [[ ${tret} == 0 ]]; then
	echo "${0##*/} finished successfully"
else
	echo "${0##*/} failed (status: ${tret})"
fi

texit
