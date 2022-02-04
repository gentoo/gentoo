# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Sphinx extension for running sphinx-apidoc on each build"
HOMEPAGE="https://pypi.org/project/sphinxcontrib-apidoc/ https://github.com/sphinx-contrib/apidoc"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/pbr[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
