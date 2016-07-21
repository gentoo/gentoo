# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="ISO 8601 date/time/duration parser and formater"
HOMEPAGE="https://pypi.python.org/pypi/isodate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	local test
	pushd "${BUILD_DIR}"/lib/
	for test in ${PN}/tests/test_*.py
	do
		if ! "${PYTHON}" $test; then
			die "Test $test failed under ${EPYTHON}"
		fi
	done
	# Give some order to the output salad
	einfo "Testsuite passed under ${EPYTHON}";einfo ""
}
