# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DISTUTILS_IN_SOURCE_BUILD="1"
RESTRICT="test"

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="https://pypi.python.org/pypi/llvmlite"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND="
	=sys-devel/llvm-3.8*
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7 python3_3)
	"
DEPEND="${RDEPEND}
	dev-util/cmake"

python_prepare_all() {
	sed -i -e 's/-flto$/-flto -fPIC/' \
		-e 's/-static-libstdc++ //' ffi/Makefile.linux || die

	# disable test using installed instance to read version info
	sed -e 's:test_version:_&:' -i llvmlite/tests/test_binding.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m "llvmlite.tests" || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
