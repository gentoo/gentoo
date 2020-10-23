# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Python interface to the PROJ library"
HOMEPAGE="https://github.com/pyproj4/pyproj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/_p/.post}.tar.gz"

S="${WORKDIR}/${P/_p/.post}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

RDEPEND=">=sci-libs/proj-6.2.0:="
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		sci-libs/shapely[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_prepare_all() {
	if has_version ">=sci-libs/proj-7.1"; then
		eapply "${FILESDIR}"/${P}-tests.patch
	fi
	distutils-r1_python_prepare_all
}

distutils-r1_src_test() {
	# workaround circular import error
	# https://github.com/pyproj4/pyproj/issues/647
	mkdir ../mytest || die
	cp -r test ../mytest || die
	cd ../mytest || die
	_distutils-r1_run_foreach_impl python_test
	_distutils-r1_run_foreach_impl _distutils-r1_clean_egg_info
}

python_test() {
	PROJ_LIB="${EPREFIX}/usr/share/proj" pytest -ra || die
}
