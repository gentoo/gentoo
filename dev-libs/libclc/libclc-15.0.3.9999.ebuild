# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake llvm llvm.org python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS=""
IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_r600 video_cards_radeonsi"
IUSE="${IUSE_VIDEO_CARDS}"
REQUIRED_USE="|| ( ${IUSE_VIDEO_CARDS} )"

LLVM_MAX_SLOT=15
BDEPEND="
	${PYTHON_DEPS}
	|| (
		sys-devel/clang:15
		sys-devel/clang:14
		sys-devel/clang:13
	)
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

llvm_check_deps() {
	has_version -b "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	# we do not need llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local libclc_targets=()

	use video_cards_nvidia && libclc_targets+=(
		"nvptx--"
		"nvptx64--"
		"nvptx--nvidiacl"
		"nvptx64--nvidiacl"
	)
	use video_cards_r600 && libclc_targets+=(
		"r600--"
	)
	use video_cards_radeonsi && libclc_targets+=(
		"amdgcn--"
		"amdgcn-mesa-mesa3d"
		"amdgcn--amdhsa"
	)
	# TODO: spirv
	[[ ${#libclc_targets[@]} ]] || die "libclc target missing!"

	libclc_targets=${libclc_targets[*]}
	local mycmakeargs=(
		-DLIBCLC_TARGETS_TO_BUILD="${libclc_targets// /;}"
		-DLLVM_CONFIG="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
	)
	cmake_src_configure
}
