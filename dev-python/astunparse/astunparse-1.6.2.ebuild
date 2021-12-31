# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Astun parser for python"
HOMEPAGE="https://github.com/simonpercivall/astunparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.23.0[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	dodoc *.rst
}
