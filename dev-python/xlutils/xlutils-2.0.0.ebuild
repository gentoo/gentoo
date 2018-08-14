# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="provides a collection of utilities for working with Excel files"
HOMEPAGE="https://pypi.org/project/xlutils/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/xlwt[${PYTHON_USEDEP}]
	dev-python/xlrd[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		dev-python/errorhandler[${PYTHON_USEDEP}]
		dev-python/manuel[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)"

python_test() {
	py.test -v xlutils/tests || die "Tests fail with ${EPYTHON}"
}
