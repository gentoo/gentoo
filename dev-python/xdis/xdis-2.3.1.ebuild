# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit distutils-r1

DESCRIPTION="Python cross-version byte-code disassembler and marshal routines"
HOMEPAGE="https://github.com/rocky/python-xdis/ https://pypi.python.org/pypi/xdis"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Remove the 3.3 specific code from being run
	rm -R "test_unit/3.3" || die
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH="${S}/test:${S}/test_unit:${BUILD_DIR}/lib" \
		py.test -v || die "Tests failed under ${EPYTHON}"
	cd test
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" \
		${EPYTHON} test_pyenvlib.py --verify --simple --compile || die \
		"Tests failed under ${EPYTHON}"
}
