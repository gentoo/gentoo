# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="A sphinx extension to include jinja based templates into a sphinx doc"
HOMEPAGE="https://github.com/tardyp/sphinx-jinja https://pypi.org/project/sphinx-jinja/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.0[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/sphinx-testing[${PYTHON_USEDEP}] )"

python_prepare() {
	if python_is_python3; then
		sed -i -e "s/import urllib/import urllib.request as urllib/" sphinxcontrib/jinja.py || die
	fi
}

python_test() {
	nosetests || die
}
