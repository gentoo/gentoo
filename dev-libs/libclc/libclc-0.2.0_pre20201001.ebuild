# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit cmake llvm prefix python-any-r1 toolchain-funcs

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"
# libclc subdir of https://github.com/llvm/llvm-project.git
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_r600 video_cards_radeonsi"
IUSE="${IUSE_VIDEO_CARDS}"
REQUIRED_USE="|| ( ${IUSE_VIDEO_CARDS} )"

BDEPEND="
	|| (
		sys-devel/clang:12
		sys-devel/clang:11
		sys-devel/clang:10
	)
	${PYTHON_DEPS}"

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	# we do not need llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local libclc_targets=()

	use video_cards_nvidia && libclc_targets+=("nvptx--" "nvptx64--" "nvptx--nvidiacl" "nvptx64--nvidiacl")
	use video_cards_r600 && libclc_targets+=("r600--")
	use video_cards_radeonsi && libclc_targets+=("amdgcn--" "amdgcn-mesa-mesa3d" "amdgcn--amdhsa")
	# TODO: spirv
	[[ ${#libclc_targets[@]} ]] || die "libclc target missing!"

	libclc_targets=${libclc_targets[*]}
	local mycmakeargs=(
		-DLIBCLC_TARGETS_TO_BUILD="${libclc_targets// /;}"
		-DLLVM_CONFIG="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
	)
	cmake_src_configure
}
