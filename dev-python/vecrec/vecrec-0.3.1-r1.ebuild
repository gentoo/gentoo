# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="2D vector and rectangle classes"
HOMEPAGE="https://github.com/kxgames/vecrec
	https://pypi.org/project/vecrec/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="dev-python/autoprop[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/addopts/d' -i tests/pytest.ini || die
	sed -e '/build-backend/s/flit.buildapi/flit_core.buildapi/' \
		-e '/requires/s/flit/flit_core/' -i pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	epytest tests
}
