# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
CMAKE_ECLASS=cmake

inherit cmake-multilib llvm python-any-r1

MY_PV="830067832d4af0fbd5710e9a45669a02fcfb7c3f"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="LLVM intrinsics representing SIMD semantics of a program targeting GPU"
HOMEPAGE="https://github.com/intel/vc-intrinsics"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="10"
KEYWORDS="~amd64"
IUSE="test"

LLVM_MAX_SLOT=10

COMMON="sys-devel/llvm:10=[${MULTILIB_USEDEP}]"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"
BDEPEND="${PYTHON_DEPS}
	test? ( dev-python/lit )"

RESTRICT="!test? ( test )"

DOCS=( Readme.md )

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20200904-cmake_libdir.patch
)

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		-DLLVM_DIR="$(get_llvm_prefix ${LLVM_MAX_SLOT})"/$(get_libdir)/cmake/llvm
		-DTARGET_LIBDIR=$(get_libdir)
	)
	if use test; then
		mycmakeargs+=(
			-DVC_INTR_ENABLE_LIT_TESTS=ON
			-DLLVM_EXTERNAL_LIT="${EPREFIX}"/usr/bin/lit
		)
	fi

	cmake_src_configure
}

multilib_src_test() {
	# These tests only work on native builds
	if multilib_is_native_abi; then
		cmake_build check-vc-intrinsics
	fi
}
