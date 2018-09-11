# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )

inherit distutils-r1 llvm

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmlite.pydata.org/"
SRC_URI="https://github.com/numba/llvmlite/archive/v${PV/_/}.tar.gz -> ${P/_/}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

LLVM_MAX_SLOT=6

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=sys-devel/llvm-6.0.0-r1:${LLVM_MAX_SLOT}
	sys-libs/zlib:0=
	virtual/python-enum34[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${P/_/}

PATCHES=(
	"${FILESDIR}"/llvmlite-0.15.0-use-system-six.patch
)

python_prepare_all() {
	# disable -flto, we do not force it against user's wishes
	# add -fPIC, needed to link against shared libraries
	# plus use those vars to force our CXXFLAGS/LDFLAGS in...
	export CXX_FLTO_FLAGS="${CXXFLAGS} -fPIC"
	export LD_FLTO_FLAGS="${LDFLAGS} -fPIC"
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" runtests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
