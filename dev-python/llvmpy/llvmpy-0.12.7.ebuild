# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/llvmpy/llvmpy-0.12.7.ebuild,v 1.4 2015/04/08 08:05:05 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmpy.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

# fails with llvm-3.4
RDEPEND="=sys-devel/llvm-3.3*:=[multitarget]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
# Usual; req'd for tests
DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${PN}-0.12.2-return-type.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_compile() {
	if ! python_is_python3; then
		local CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
		export CXXFLAGS
	fi
	distutils-r1_python_compile
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	${PYTHON} -c "import llvm; llvm.test()" || die
}

python_install() {
	if ! python_is_python3; then
		local CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
		export CXXFLAGS
	fi
	distutils-r1_python_install
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html )
	distutils-r1_python_install_all
}
