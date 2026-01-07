# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Generic testsuite framework in Python"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-ada/e3-core[${PYTHON_USEDEP}]
	test? ( dev-python/coverage[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/sphinx-rtd-theme dev-python/sphinx-autoapi

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
