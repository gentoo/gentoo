# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="HTTP client/server for asyncio"
HOMEPAGE="https://github.com/KeepSafe/aiohttp https://pypi.python.org/pypi/aiohttp"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/python-asyncio[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
