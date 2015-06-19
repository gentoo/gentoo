#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/tests/eutils_path_exists.sh,v 1.2 2015/05/10 16:38:08 ulm Exp $

source tests-common.sh

inherit eutils

test-path_exists() {
	local exp=$1; shift
	tbegin "path_exists($*) == ${exp}"
	path_exists "$@"
	[[ ${exp} -eq $? ]]
	tend $?
}

test-path_exists 1
test-path_exists 1 -a
test-path_exists 1 -o

good="/ . tests-common.sh /bin/bash"
test-path_exists 0 ${good}
test-path_exists 0 -a ${good}
test-path_exists 0 -o ${good}

bad="/asjdkfljasdlfkja jlakjdsflkasjdflkasdjflkasdjflaskdjf"
test-path_exists 1 ${bad}
test-path_exists 1 -a ${bad}
test-path_exists 1 -o ${bad}

test-path_exists 1 ${good} ${bad}
test-path_exists 1 -a ${good} ${bad}
test-path_exists 0 -o ${good} ${bad}

texit
