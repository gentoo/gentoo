# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="ISO 8601 date/time/duration parser and formatter"
HOMEPAGE="https://pypi.python.org/pypi/isodate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	local testfile
	pushd "${BUILD_DIR}"/lib/ || die
	for test in ${PN}/tests/test_*.py; do
		if ! "${PYTHON}" "${testfile}"; then
			die "Test ${testfile} failed under ${EPYTHON}"
		fi
	done

	# Give some order to the output salad.
	einfo "Testsuite passed under ${EPYTHON}";
	einfo ""
}
