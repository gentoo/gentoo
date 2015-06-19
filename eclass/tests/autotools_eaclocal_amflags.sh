#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/autotools_eaclocal_amflags.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit autotools

test-it() {
	tbegin "eaclocal_amflags $1: $2"
	printf "ACLOCAL_AMFLAGS = %b\n" "$2" > Makefile.am
	local flags=$(eaclocal_amflags) exp=${3:-$2}
	[[ "${flags}" == "${exp}" ]]
	if ! tend $? ; then
		printf '### INPUT:\n%s\n' "$2"
		printf '### FILE:\n%s\n' "$(<Makefile.am)"
		printf '### EXPECTED:\n%s\n' "${exp}"
		printf '### ACTUAL:\n%s\n' "${flags}"
	fi
	rm Makefile.am
}

test-it simple "-Im4"
test-it simple "-I m4 -I lakdjfladsfj /////"

test-it shell-exec '`echo hi`' "hi"
test-it shell-exec '`echo {0..3}`' "0 1 2 3"

test-it multiline '-I oneline \\\n\t-I twoline' "-I oneline -I twoline"

texit
