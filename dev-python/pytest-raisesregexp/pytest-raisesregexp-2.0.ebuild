# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="Simple pytest plugin to look for regex in Exceptions"
HOMEPAGE="https://github.com/Walkman/pytest_raisesregexp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${CDEPEND} )
"
RDEPEND="
	${CDEPEND}
	dev-python/py[${PYTHON_USEDEP}]
"

python_test() {
	${PYTHON} -m pytest || die "Tests failed under ${EPYTHON}"
}
