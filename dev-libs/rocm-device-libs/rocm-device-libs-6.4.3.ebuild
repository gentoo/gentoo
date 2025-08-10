# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 20 )
inherit cmake flag-o-matic llvm-r1

MY_P=llvm-project-rocm-${PV}
components=( "amd/device-libs" )

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/llvm-project"
	inherit git-r3
	S="${WORKDIR}/${P}/${components[0]}"
else
	SRC_URI="https://github.com/ROCm/llvm-project/archive/rocm-${PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}/${components[0]}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/ROCm/llvm-project/tree/amd-staging/amd/device-libs"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-build/rocm-cmake
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
		llvm-core/lld:${LLVM_SLOT}
	')
"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-6.1.0-fix-llvm-link.patch"
	"${FILESDIR}/${PN}-6.2.0-test-bitcode-dir.patch"
	"${FILESDIR}/${PN}-6.4.2-cmake-4-compat.patch"
)

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_fetch
		git-r3_checkout '' . '' "${components[@]}"
	else
		archive="${MY_P}.tar.gz"
		ebegin "Unpacking from ${archive}"
		tar -x -z -o \
			-f "${DISTDIR}/${archive}" \
			"${components[@]/#/${MY_P}/}" || die
		eend ${?}
	fi
}

src_prepare() {
	sed -e "s:amdgcn/bitcode:lib/amdgcn/bitcode:" \
		-i "${S}/cmake/OCL.cmake" \
		-i "${S}/cmake/Packages.cmake" || die
	cmake_src_prepare
}

src_configure() {
	# Do not trust CMake with autoselecting Clang, as it autoselects the latest one
	# producing too modern LLVM bitcode and causing linker errors in other packages.
	llvm_prepend_path "${LLVM_SLOT}"
	local -x CC=${CHOST}-clang
	local -x CXX=${CHOST}-clang++
	# Clean up unsupported flags for the switched compiler, see #936099
	strip-unsupported-flags

	cmake_src_configure
}

src_install() {
	cmake_src_install
	# install symlink, so that clang won't ask for "--rocm-device-lib-path" flag anymore
	local bitcodedir="$(clang -print-resource-dir)/$(get_libdir)/amdgcn/bitcode"
	dosym -r "/usr/lib/amdgcn/bitcode" "${bitcodedir#${EPREFIX}}"
}

src_test() {
	# https://github.com/ROCm/llvm-project/issues/76
	# "Failing tests are on gfx that are not supported"
	local CMAKE_SKIP_TESTS=(
		compile_fract__gfx600
		compile_fract__gfx700
	)

	cmake_src_test
}
