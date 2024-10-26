# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )
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
HOMEPAGE="https://github.com/ROCm/ROCm-Device-Libs"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-build/rocm-cmake
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}
		sys-devel/lld:${LLVM_SLOT}
	')
"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-5.5.0-test-bitcode-dir.patch"
	"${FILESDIR}/${PN}-6.1.0-fix-llvm-link.patch"
	"${FILESDIR}/${PN}-6.0.0-add-gws-attribute.patch"
	"${FILESDIR}/${PN}-6.1.0-fix-test-failures.patch"
	"${FILESDIR}/${PN}-6.1.0-fix-test-failures2.patch"
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
	sed -e "s:amdgcn/bitcode:lib/amdgcn/bitcode:" -i "${S}/cmake/OCL.cmake" || die
	sed -e "s:amdgcn/bitcode:lib/amdgcn/bitcode:" -i "${S}/cmake/Packages.cmake" || die
	cmake_src_prepare
}

src_configure() {
	# Do not trust CMake with autoselecting Clang, as it autoselects the latest one
	# producing too modern LLVM bitcode and causing linker errors in other packages.
	# Clean up unsupported flags for the switched compiler, see #936099
	local -x CC="$(get_llvm_prefix)/bin/clang"
	local -x CXX="$(get_llvm_prefix)/bin/clang++"
	strip-unsupported-flags

	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	local CLANG_EXE="$(get_llvm_prefix)/bin/clang"
	# install symlink, so that clang won't ask for "--rocm-device-lib-path" flag anymore
	local bitcodedir="$("${CLANG_EXE}" -print-resource-dir)/$(get_libdir)/amdgcn/bitcode"
	dosym -r "/usr/lib/amdgcn/bitcode" "${bitcodedir#${EPREFIX}}"
}
