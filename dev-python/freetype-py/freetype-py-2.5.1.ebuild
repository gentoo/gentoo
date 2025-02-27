# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="FreeType Python bindings"
HOMEPAGE="
	https://github.com/rougier/freetype-py/
	https://pypi.org/project/freetype-py/
"
SRC_URI="$(pypi_sdist_url --no-normalize "${PN}" "${PV}" .zip)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/freetype
"
BDEPEND="
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
