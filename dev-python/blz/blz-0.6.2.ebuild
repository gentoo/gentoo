# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Chunked, compressed, Python data container for memory and disk"
HOMEPAGE="http://blz.pydata.org/"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/c-blosc
	>=dev-python/numexpr-2.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.19[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	export BLOSC_DIR="${EPREFIX}/usr"
	# remove forced sse2
	sed -i "s|CFLAGS\.append(\"-msse2\")|pass|" setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${PYTHON} -c 'import blz; blz.test()' || die
}

python_install_all() {
	# doc needs obsolete sphnxjp package
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
