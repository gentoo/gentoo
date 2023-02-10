#!/bin/bash
# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit pypi

test-eq() {
	local call=${1}
	local exp=${2}

	tbegin "${call} -> ${exp}"
	local ret=0
	local have=$(${call})
	if [[ ${have} != ${exp} ]]; then
		eindent
		eerror "incorrect result: ${have}"
		eoutdent
		ret=1
	fi
	tend "${ret}"
}

test-eq "pypi_normalize_name foo" foo
test-eq "pypi_normalize_name foo_bar" foo_bar
test-eq "pypi_normalize_name foo___bar" foo_bar
test-eq "pypi_normalize_name Flask-BabelEx" flask_babelex
test-eq "pypi_normalize_name jaraco.context" jaraco_context

texit
