# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 toolchain-funcs flag-o-matic

DESCRIPTION="Optimized cosmic ray annihilation astropy python module"
HOMEPAGE="https://github.com/astropy/astroscrappy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="BSD"
SLOT="0"
IUSE="doc openmp test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${P}-dont-install-binary.patch"
	"${FILESDIR}/${P}-endian-fix-tests.patch"
	"${FILESDIR}/${P}-numpy-fix-tests.patch"
	"${FILESDIR}/${P}-respect-user-flag.patch"
)

DOCS=( CHANGES.rst )

python_prepare_all() {
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	use openmp && tc-has-openmp && append-flags -fopenmp
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
