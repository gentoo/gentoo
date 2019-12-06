# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Python < 3.6 requires https://pypi.org/project/aenum/
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python interface to the PROJ library"
HOMEPAGE="https://github.com/jswhit/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

RDEPEND=">=sci-libs/proj-6.2.0"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( $(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]') )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		sci-libs/Shapely[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_check_deps() {
	use doc && has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	append-cflags -fno-strict-aliasing
}

python_test() {
	PROJ_LIB="${EPREFIX}/usr/share/proj" pytest -ra || die
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
