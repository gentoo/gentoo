# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( pypy{,3} python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Redis distributed locks in Python"
HOMEPAGE="https://github.com/SPSCommerce/redlock-py https://pypi.python.org/pypi/redlock-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-python/redis-py[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"
