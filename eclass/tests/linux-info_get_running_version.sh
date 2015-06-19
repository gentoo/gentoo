#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/linux-info_get_running_version.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit linux-info

test_get_running_version() {
	local test_kv=$1 major=$2 minor=$3 patch=$4 extra=$5
	tbegin "get_running_version ${test_kv}"
	uname() { echo "${test_kv}" ; }
	ROOT=/:/:/:/: get_running_version
	local r=$?
	[[ ${r} -eq 0 &&
	   ${major} == "${KV_MAJOR}" &&
	   ${minor} == "${KV_MINOR}" &&
	   ${patch} == "${KV_PATCH}" &&
	   ${extra} == "${KV_EXTRA}" ]]
	tend $? "FAIL: {ret: ${r}==0} {major: ${major}==${KV_MAJOR}} {minor: ${minor}==${KV_MINOR}} {patch: ${patch}==${KV_PATCH}} {extra: ${extra}==${KV_EXTRA}}"
}

tests=(
	# KV_FULL				MAJOR	MINOR	PATCH	EXTRA
	1.2.3					1		2		3		''
	1.2.3.4					1		2		3		.4
	1.2.3-ver+1.4			1		2		3		-ver+1.4
	1.2-kern.3				1		2		0		-kern.3
	1.2+kern.5				1		2		0		+kern.5
	1.2.3_blah				1		2		3		_blah
	3.2.1-zen-vs2.3.2.5+	3		2		1		-zen-vs2.3.2.5+
)

for (( i = 0; i < ${#tests[@]}; i += 5 )) ; do
	test_get_running_version "${tests[@]:i:5}"
done

texit
