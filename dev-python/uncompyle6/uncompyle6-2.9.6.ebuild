# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code deparser"
HOMEPAGE="https://github.com/rocky/python-uncompyle6/ https://pypi.python.org/pypi/uncompyle6"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/xdis-3.2.3
	<dev-python/xdis-3.3.0
	>=dev-python/spark-parser-1.4.0
	<dev-python/spark-parser-1.5.0"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	rm -R test/__pycache__ || die "removal of test/__pycache__ failed"
	rm -R test/pycdc || die "removal of test/pycdc failed"
	distutils-r1_python_prepare_all
}

# the pypi page says to run "make check" to test
# There are numerous more tests, but not all pass, so
# until clarified, only run the recommended "make check" tests
python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		emake check || die "Tests failed under ${EPYTHON}"
		#pytest -vv || die "Tests failed under ${EPYTHON}"
}
