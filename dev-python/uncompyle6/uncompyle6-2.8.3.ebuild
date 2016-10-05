# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code deparser"
HOMEPAGE="https://github.com/rocky/python-uncompyle6/ https://pypi.python.org/pypi/umcompyle6"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/xdis-2.3.0
	>=dev-python/spark-parser-1.4.0"
DEPEND="${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

# Tests are somewhat sketchy...
# the main repo has makefiles and commands that don't reflect the actual
# available options for the commands they are giving.
# This test does not produce errors, but also does not seem to update the
# files ok, failed,...  just the # of files tested
python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		${EPYTHON} test/test_pyenvlib.py --verify --all || die \
		"Tests failed under ${EPYTHON}"
}
