# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Astun parser for python"
HOMEPAGE="https://github.com/simonpercivall/astunparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.23.0[${PYTHON_USEDEP}]
"
PATCHES=(
	"${FILESDIR}/astunparse-1.6.2-tests.patch"
)

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
	dodoc *.rst
}
