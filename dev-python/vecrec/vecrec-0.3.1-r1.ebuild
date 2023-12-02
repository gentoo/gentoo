# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="2D vector and rectangle classes"
HOMEPAGE="
	https://github.com/kxgames/vecrec/
	https://pypi.org/project/vecrec/
"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64"
SLOT="0"

RDEPEND="
	dev-python/autoprop[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/build-backend/s/flit.buildapi/flit_core.buildapi/' \
		-e '/requires/s/flit/flit_core/' -i pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -o addopts= tests
}
