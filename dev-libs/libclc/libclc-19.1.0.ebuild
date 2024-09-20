# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( {17..18} )
PYTHON_COMPAT=( python3_{10..13} )
inherit cmake llvm.org llvm-r1 python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="+spirv video_cards_nvidia video_cards_r600 video_cards_radeonsi"

BDEPEND="
	${PYTHON_DEPS}
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		spirv? ( dev-util/spirv-llvm-translator:${LLVM_SLOT} )
	')
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

pkg_setup() {
	llvm-r1_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	local libclc_targets=()

	use spirv && libclc_targets+=(
		"spirv-mesa3d-"
		"spirv64-mesa3d-"
	)
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
	[[ ${#libclc_targets[@]} ]] || die "libclc target missing!"

	libclc_targets=${libclc_targets[*]}
	local mycmakeargs=(
		-DLIBCLC_TARGETS_TO_BUILD="${libclc_targets// /;}"
	)
	cmake_src_configure
}
