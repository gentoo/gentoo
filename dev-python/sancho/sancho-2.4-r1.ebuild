# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="Sancho-${PV}"

DESCRIPTION="Sancho is a unit testing framework"
HOMEPAGE="http://www.mems-exchange.org/software/sancho/"
SRC_URI="http://www.mems-exchange.org/software/files/${PN}/${MY_P}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_test() {
	cd test
	local test test_failure test_failure_count=0
	for test in *.py; do
		test_failure="0"
		ebegin "Testing ${test}"
		"${PYTHON}" "${test}" > "${test}.output"
		grep -Eqv "^${test}: .*:$" "${test}.output" && test_failure="1"
		eend "${test_failure}"
		if [[ "${test_failure}" == "1" ]]; then
			((test_failure_count++))
			eerror "Failure output for ${test}"
			cat "${test}.output"
		fi
	done
	if [[ "${test_failure_count}" -gt "0" ]]; then
		die "${test_failure_count} tests failed"
	fi
}
