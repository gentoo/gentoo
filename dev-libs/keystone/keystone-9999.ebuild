# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9..11} )

inherit cmake distutils-r1 llvm

DESCRIPTION="assembly/assembler framework + bindings"
HOMEPAGE="https://www.keystone-engine.org/"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/keystone-engine/keystone.git"
	inherit git-r3
else
	SRC_URI="https://github.com/keystone-engine/keystone/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
fi
S="${WORKDIR}"/${P/_rc/-rc}

LICENSE="GPL-2"
SLOT="0"

# Keep in sync with llvm/CMakeLists.txt, subset of sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 ARM Hexagon Mips PowerPC Sparc SystemZ X86 )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

IUSE="python ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=[${LLVM_TARGET_USEDEPS// /,}]
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

RESTRICT=test # only regression tests

REQUIRED_USE="
	|| ( ${ALL_LLVM_TARGETS[*]} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

# Upstream doesn't flag patch releases (bug 858395)
QA_PKGCONFIG_VERSION="$(ver_cut 1-2)"

wrap_python() {
	if use python; then
		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null || die
	fi
}

pkg_setup() {
	python_setup
}

src_prepare() {
	default

	sed -i '/NOT uppercase_CMAKE_BUILD_TYPE MATCHES/ s/DEBUG/GENTOO|DEBUG/' \
		llvm/CMakeLists.txt || die
	cmake_src_prepare
	wrap_python ${FUNCNAME}
}

src_configure() {
	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DCMAKE_CONFIGURATION_TYPES="Gentoo"
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_HOST_TRIPLE="${CHOST}"
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile
	wrap_python ${FUNCNAME}
}

src_install() {
	cmake_src_install
	wrap_python ${FUNCNAME}
}
