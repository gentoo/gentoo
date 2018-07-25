# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_5 python3_6 )
inherit distutils-r1

DESCRIPTION="Python client for Consul"
HOMEPAGE="https://github.com/cablehead/python-consul/"
SRC_URI="https://github.com/cablehead/python-consul/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/aiohttp[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	>=dev-python/treq-16[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]"
DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}]
	${RDEPEND} )"

# needs pytest-twisted
RESTRICT="test"

python_test() {
	py.test -v || die
}
