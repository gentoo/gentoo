# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_OPTIONAL=1
CMAKE_MIN_VERSION=3.8.7
PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake-utils distutils-r1

DESCRIPTION="assembly/assembler framework + bindings"
HOMEPAGE="http://www.keystone-engine.org/"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/keystone-engine/keystone.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/keystone-engine/keystone/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

# Keep in sync with llvm/CMakeLists.txt, subset of sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 ARM Hexagon Mips PowerPC Sparc SystemZ X86 )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

IUSE="python ${ALL_LLVM_TARGETS[*]}"
RDEPEND="sys-devel/llvm:=[${LLVM_TARGET_USEDEPS// /,}]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )
"

S=${WORKDIR}/${P/_rc/-rc}

CMAKE_BUILD_TYPE=RelWithDebInfo

wrap_python() {
	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null || die
	fi
}

src_prepare() {
	default
	cmake-utils_src_prepare
	wrap_python ${FUNCNAME}
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_HOST_TRIPLE="${CHOST}"
	)

	cmake-utils_src_configure
	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake-utils_src_compile
	wrap_python ${FUNCNAME}
}

src_install() {
	cmake-utils_src_install
	wrap_python ${FUNCNAME}
}
