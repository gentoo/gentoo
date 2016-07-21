# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="provides a collection of utilities for working with Excel files"
HOMEPAGE="https://pypi.python.org/pypi/xlutils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

LICENSE="MIT"
SLOT="0"

RDEPEND=">=dev-python/xlwt-0.7.3[${PYTHON_USEDEP}]
	>=dev-python/xlrd-0.7.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/errorhandler[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/testfixtures-1.6.1[${PYTHON_USEDEP}] )"

DOCS="README.txt docs/*.txt"

python_test() {
	py.test xlutils/tests
}
