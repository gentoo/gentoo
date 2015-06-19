#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/distutils-r1.sh,v 1.3 2015/05/11 17:35:52 ulm Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
source tests-common.sh

test-phase_name_free() {
	local ph=${1}

	if declare -f "${ph}"; then
		die "${ph} function declared while name reserved for phase!"
	fi
	if declare -f "${ph}_all"; then
		die "${ph}_all function declared while name reserved for phase!"
	fi
}

inherit distutils-r1

tbegin "sane function names"

test-phase_name_free python_prepare
test-phase_name_free python_configure
test-phase_name_free python_compile
test-phase_name_free python_test
test-phase_name_free python_install

tend ${failed}

texit
