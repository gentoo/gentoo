#!/bin/bash
# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

source tests-common.sh || exit

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

cleanup() {
	# make sure that these variables exist
	[[ -n ${ED} && -n ${T} && -n ${WORKDIR} ]] \
		|| { die "${FUNCNAME[0]}: undefined variable"; exit 1; }
	rm -rf "${ED}"/* "${T}"/* "${WORKDIR}"/*
}

test-it() {
	local ret=0
	tbegin "$@"
	mkdir -p "${ED}"/etc/portage/savedconfig
	: $(( ret |= $? ))
	pushd "${WORKDIR}" >/dev/null
	: $(( ret |= $? ))
	test_sc
	: $(( ret |= $? ))
	popd >/dev/null
	: $(( ret |= $? ))
	tend ${ret}
	cleanup
}

test_sc() {
	touch f || return 1
	sc f || return 1
	[[ -f ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "simple save_config"

test_sc() {
	touch a b c || return 1
	sc a b c || return 1
	[[ -d ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "multi save_config"

test_sc() {
	mkdir dir || return 1
	touch dir/{a,b,c} || return 1
	sc dir || return 1
	[[ -d ${ED}/etc/portage/savedconfig/${CATEGORY}/${PF} ]]
}
test-it "dir save_config"

PORTAGE_CONFIGROOT=${D}

test_sc() {
	echo "ggg" > f || return 1
	rc f || return 1
	[[ $(<f) == "ggg" ]]
}
test-it "simple restore_config"

test_sc() {
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
