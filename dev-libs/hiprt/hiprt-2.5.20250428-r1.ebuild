# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake edo flag-o-matic rocm toolchain-funcs

RELEASE_TAG=2.5.a21e075.3

DESCRIPTION="A ray tracing library for HIP"
HOMEPAGE="https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT"
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/archive/refs/tags/${RELEASE_TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/HIPRT-${RELEASE_TAG}"

LICENSE="MIT"
SLOT="$(ver_cut 0-2)"
KEYWORDS="~amd64"

# skipped due to UnknownUseFlags: gfx1013 gfx1032 gfx1033 gfx1034 gfx1035 gfx1036 gfx902 gfx904 gfx909 gfx90c
IUSE_TARGETS=(
	gfx1010 gfx1011 gfx1012 gfx1030 gfx1031
	gfx1100 gfx1101 gfx1102 gfx1103 gfx1150 gfx1151 gfx1152 gfx1153 gfx1200 gfx1201
	gfx900 gfx906 gfx908 gfx90a gfx942
)
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
ROCM_REQUIRED_USE=" || ( ${IUSE_TARGETS[*]} )"

IUSE="${IUSE_TARGETS[*]/#/+} debug test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip
"
DEPEND="
	dev-util/hipcc
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-2.5-no-parallel-jobs.patch"
	"${FILESDIR}/${PN}-2.5-install-path.patch"
	"${FILESDIR}/${PN}-2.5-strict-aliasing.patch"
	"${FILESDIR}/${PN}-2.5-fail-on-errors.patch"
	"${FILESDIR}/${PN}-2.5-hip7.patch"
)

src_prepare() {
	sed "s|hipSdkPathFromArgument + '/bin/clang++'|'$(tc-getHIPCXX)'|" \
		-i scripts/bitcodes/precompile_bitcode.py || die

	sed -e "s/VERBATIM/USES_TERMINAL VERBATIM/" -i CMakeLists.txt || die

	# Add support for newer AMDGPU targets and per-target compilation
	eapply "${FILESDIR}/${PN}-2.5-amdgpu-targets.patch"
	sed -e "s/__AMDGPU_TARGETS__/$(get_amdgpu_flags)/" \
		-i scripts/bitcodes/compile.py scripts/bitcodes/precompile_bitcode.py || die

	# -Wc++11-narrowing is an error in clang-22
	sed -e "s/pow(/powf(/g" -e "s/tan(/tanf(/g" -i test/shared.h || die

	cmake_src_prepare
}

src_configure() {
	# ODR violations
	filter-lto

	# Only Release and Debug targets are supported
	local CMAKE_BUILD_TYPE=$(usex debug Debug Release)

	local mycmakeargs=(
		-DHIP_PATH="${ESYSROOT}/usr"
		-DFORCE_DISABLE_CUDA=ON
		-DPRECOMPILE=ON
		-DBITCODE=ON
		-DNO_ENCRYPT=ON
		-DNO_UNITTEST=$(usex !test)
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}/usr/lib/hiprt/${SLOT}"
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu

	local -x GTEST_FILTER="-hiprtTest.CudaEnabled"

	pushd dist > /dev/null || die
	edo ./bin/$(usex debug Debug Release)/unittest64
	popd > /dev/null || die
}
