# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmlite.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	=sys-devel/llvm-3.9*
	sys-libs/zlib:0=
	virtual/python-enum34[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
PATCHES=(
	"${FILESDIR}"/llvmlite-0.15.0-use-system-six.patch
)

python_prepare_all() {
	# remove -static-libstdc++, it makes no sense with shared LLVM
	# add -fPIC, needed to link against shared libraries
	# disable -flto, we do not force it against user's wishes
	sed -e 's/-static-libstdc++/-fPIC/' \
		-e '/^(CXX|LD)_FLTO_FLAGS/d' \
		-i ffi/Makefile.linux || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" runtests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
