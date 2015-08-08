#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source tests-common.sh

inherit savedconfig

quiet() {
	local out ret
	out=$("$@" 2>&1)
	ret=$?
	[[ ${ret} -eq 0 ]] || echo "${out}"
	return ${ret}
}
sc() { EBUILD_PHASE=install quiet save_config "$@" ; }
rc() { EBUILD_PHASE=prepare quiet restore_config "$@" ; }

cleanup() { rm -rf "${ED}"/* "${T}"/* "${WORKDIR}"/* ; }
test-it() {
	local ret=0
	tbegin "$@"
	mkdir -p "${ED}"/etc/portage/savedconfig
	: $(( ret |= $? ))
	pushd "${WORKDIR}" >/dev/null
	: $(( ret |= $? ))
	test
	: $(( ret |= $? ))
	popd >/dev/null
	: $(( ret |= $? ))
	tend ${ret}
	cleanup
}

test() {
	touch f || return 1
	sc f || return 1
	[[ -f ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "simple save_config"

test() {
	touch a b c || return 1
	sc a b c || return 1
	[[ -d ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "multi save_config"

test() {
	mkdir dir || return 1
	touch dir/{a,b,c} || return 1
	sc dir || return 1
	[[ -d ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "dir save_config"

PORTAGE_CONFIGROOT=${D}

test() {
	echo "ggg" > f || return 1
	rc f || return 1
	[[ $(<f) == "ggg" ]]
}
test-it "simple restore_config"

test() {
	echo "ggg" > f || return 1
	rc f || return 1
	[[ $(<f) == "ggg" ]] || return 1
	sc f || return 1

	echo "hhh" > f || return 1
	rc f || return 1
	[[ $(<f) == "ggg" ]]
}
test-it "simple restore+save config"

texit
