# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A sphinx extension to include jinja based templates into a sphinx doc"
HOMEPAGE="https://github.com/tardyp/sphinx-jinja https://pypi.org/project/sphinx-jinja/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/sphinx-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

src_prepare() {
	sed -e "s/import urllib/import urllib.request as urllib/" \
		-i sphinxcontrib/jinja.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
