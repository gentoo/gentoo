# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 23 )
inherit cmake flag-o-matic llvm-r2

MY_P=llvm-project-therock-${PV%.0}
components=( "amd/device-libs" )

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/llvm-project"
	inherit git-r3
	S="${WORKDIR}/${P}/${components[0]}"
else
	SRC_URI="https://github.com/ROCm/llvm-project/archive/therock-${PV%.0}.tar.gz -> ${MY_P}.tar.gz"
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
	$(llvm_gen_dep "
		llvm-core/clang:\${LLVM_SLOT}
		llvm-core/lld:\${LLVM_SLOT}
	")
"

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-test-bitcode-dir.patch"
	"${FILESDIR}/${PN}-10.1.0-update-stale-tests.patch"
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
		-i cmake/OCL.cmake \
		-i cmake/Packages.cmake || die
	# shellcheck disable=SC2016
	sed -e 's:${CMAKE_INSTALL_DATADIR}/doc/${CPACK_PACKAGE_NAME}:${CMAKE_INSTALL_DOCDIR}:' \
		-i CMakeLists.txt || die
	# test expects "entry:" labels, which are dropped by clang built without assertions;
	# also quote COMPILE_FLAGS, so that multiple flags are passed to the test script
	# shellcheck disable=SC2016
	sed -e "s/COMPILE_FLAGS -emit-llvm)/COMPILE_FLAGS -emit-llvm -fno-discard-value-names)/" \
		-e 's/-DCOMPILE_FLAGS=${COMPILE_TEST_COMPILE_FLAGS}$/"&"/' \
		-i test/compile/CMakeLists.txt || die
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
	dosym -r "/usr/lib/amdgcn/bitcode" "${bitcodedir#"${EPREFIX}"}"
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# clang-23 hangs
		compile_native_rsqrt__gfx600
		compile_native_rsqrt__gfx700
		# expects llvm.amdgcn.rcp not to be constant folded (newer LLVM)
		constant_fold_lgamma_r__*
		# requires https://github.com/llvm/llvm-project/pull/201435 (LLVM 24)
		compile_trig_nan_guard__*
	)

	cmake_src_test
}
