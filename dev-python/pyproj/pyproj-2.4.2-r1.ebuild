# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Python < 3.6 requires https://pypi.org/project/aenum/
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python interface to the PROJ library"
HOMEPAGE="https://github.com/jswhit/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="doc"

RDEPEND=">=sci-libs/proj-6.2.0:="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		sci-libs/Shapely[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${P}-conftest.patch )

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	PROJ_LIB="${EPREFIX}/usr/share/proj" pytest -ra || die
}
