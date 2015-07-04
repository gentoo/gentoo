# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/regex/regex-2015.06.24.ebuild,v 1.1 2015/07/04 05:59:41 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Alternative regular expression module to replace re"
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DOCS=( README docs/Features.rst docs/UnicodeProperties.txt )

python_compile() {
	if ! python_is_python3; then
		local CFLAGS=${CFLAGS}
		append-cflags -fno-strict-aliasing
	fi
	distutils-r1_python_compile
}

python_test() {
	local msg="tests failed under ${EPYTHON}"
	# https://bitbucket.org/mrabarnett/mrab-regex/issue/145/1-fail-in-testsuite-under-pypy
	einfo "There is one trivial fail of test test_empty_array under pypy"

	if python_is_python3; then
		"${PYTHON}" Python3/test_regex.py || die $msg
	else
		"${PYTHON}" Python2/test_regex.py || die $msg
	fi
}
