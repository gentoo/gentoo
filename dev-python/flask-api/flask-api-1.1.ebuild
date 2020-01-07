# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Browsable web APIs for Flask"
HOMEPAGE="https://github.com/flask-api/flask-api"
# pypi mirror don't have docs folder
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_install_all() {
	distutils-r1_python_install_all
	dodoc docs/about/* docs/api-guide/* docs/index.md
}

python_test() {
	pytest -vv || die
}
