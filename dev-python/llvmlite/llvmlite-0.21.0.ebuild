# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 llvm

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmlite.pydata.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

LLVM_MAX_SLOT=5

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	sys-devel/llvm:${LLVM_MAX_SLOT}
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
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
