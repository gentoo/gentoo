# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1 llvm

DESCRIPTION="Python wrapper around the llvm C++ library"
HOMEPAGE="http://llvmlite.pydata.org/"
SRC_URI="https://github.com/numba/llvmlite/archive/v${PV/_/}.tar.gz -> ${P/_/}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

LLVM_MAX_SLOT=8

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	sys-devel/llvm:${LLVM_MAX_SLOT}
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

python_configure_all() {
	# upstream's build system is just horrible, and they ignored the PR
	# fixing it, so let's build the shared lib properly using implicit
	# make rules

	export LDLIBS=$(llvm-config --libs all)
	export CXXFLAGS="$(llvm-config --cxxflags) -fPIC ${CXXFLAGS}"
	export LDFLAGS="$(llvm-config --ldflags) ${LDFLAGS}"

	local files=( ffi/*.cpp )
	emake -f - <<EOF
ffi/libllvmlite.so: ${files[*]/.cpp/.o}
	\$(CXX) -shared \$(CXXFLAGS) \$(LDFLAGS) -o \$@ \$^ \$(LDLIBS)
EOF
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
