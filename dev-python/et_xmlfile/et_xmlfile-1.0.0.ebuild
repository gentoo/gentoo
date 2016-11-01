# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="An implementation of lxml.xmlfile for the standard library"
HOMEPAGE="https://pypi.python.org/pypi/et_xmlfile https://bitbucket.org/openpyxl/et_xmlfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	py.test -vv || die
}
