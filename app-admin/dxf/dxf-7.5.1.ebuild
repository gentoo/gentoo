# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Docker registry v2 client in Python"
HOMEPAGE="https://github.com/davedoesdev/dxf"
SRC_URI="https://github.com/davedoesdev/dxf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-python/jwcrypto-0.4.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.18.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.19.4[${PYTHON_USEDEP}]
	>=dev-python/www-authenticate-0.9.2[${PYTHON_USEDEP}]"

RESTRICT="test"
# Require dockerd running

python_test() {
	emake test
}
