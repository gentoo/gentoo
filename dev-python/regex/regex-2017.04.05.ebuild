# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Alternative regular expression module to replace re"
HOMEPAGE="https://bitbucket.org/mrabarnett/mrab-regex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd"
IUSE="doc"

DOCS=( README docs/UnicodeProperties.txt )

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

python_install_all() {
	local DOCS="${DOCS} docs/UnicodeProperties.txt"
	use doc && local HTML_DOCS=( docs/Features.html )

	distutils-r1_python_install_all
}
