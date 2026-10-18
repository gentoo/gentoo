# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit cmake llvm.org multibuild python-any-r1

DESCRIPTION="OpenCL C library"
HOMEPAGE="https://libclc.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( MIT BSD )"
SLOT="0"
IUSE="+spirv test video_cards_nvidia video_cards_radeonsi"
RESTRICT="!test? ( test )"

BDEPEND="
	${PYTHON_DEPS}
	llvm-core/clang:${LLVM_MAJOR}
	spirv? (
		>=dev-util/spirv-llvm-translator-23:*
	)
	test? (
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
	)
"

LLVM_COMPONENTS=( libclc )
llvm.org_set_globals

src_configure() {
	MULTIBUILD_VARIANTS=()

	use spirv && MULTIBUILD_VARIANTS+=(
		"spirv32-unknown-unknown"
		"spirv64-unknown-unknown"
		"spirv64-unknown-vulkan"  # formerly clspv
	)
	use video_cards_nvidia && MULTIBUILD_VARIANTS+=(
		"nvptx64-nvidia-cuda"
	)
	use video_cards_radeonsi && MULTIBUILD_VARIANTS+=(
		"amdgcn-amd-amdhsa-llvm"
	)

	multibuild_foreach_variant my_configure
}

my_configure() {
	local mycmakeargs=(
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DCMAKE_CLC_COMPILER="$(type -P clang-${LLVM_MAJOR})"
		-DLLVM_DEFAULT_TARGET_TRIPLE="${MULTIBUILD_VARIANT}"
		-DLLVM_INCLUDE_TESTS="$(usex test)"
	)

	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	cmake_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	multibuild_foreach_variant cmake_build check-libclc
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
