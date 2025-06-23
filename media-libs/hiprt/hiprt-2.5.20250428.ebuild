# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake edo flag-o-matic rocm

RELEASE_TAG=2.5.a21e075.3

DESCRIPTION="A ray tracing library for HIP"
HOMEPAGE="https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT"
SRC_URI="https://github.com/GPUOpen-LibrariesAndSDKs/HIPRT/archive/refs/tags/${RELEASE_TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/HIPRT-${RELEASE_TAG}"

LICENSE="MIT"
SLOT="$(ver_cut 0-2)"
KEYWORDS="~amd64"
IUSE="cuda debug test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
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
)

src_prepare() {
	local hipclangpath
	if ! hipclangpath=$(hipconfig --hipclangpath); then
		die "Error: \"hipconfig --hipclangpath\" failed"
	fi

	sed "s|hipSdkPathFromArgument + '/bin/clang++'|'${hipclangpath}/clang++'|" \
		-i scripts/bitcodes/precompile_bitcode.py || die
	cmake_src_prepare
}

src_configure() {
	# ODR violations
	filter-lto

	# Only Release and Debug targets are supported
	local CMAKE_BUILD_TYPE=$(usex debug Debug Release)

	local mycmakeargs=(
		-DHIP_PATH="${ESYSROOT}/usr"
		-DFORCE_DISABLE_CUDA=$(usex cuda OFF ON)
		-DPRECOMPILE=ON
		-DBITCODE=ON
		-DNO_ENCRYPT=ON
		-DNO_UNITTEST=$(usex test OFF ON)
		-DCMAKE_INSTALL_PREFIX="${ESYSROOT}/usr/lib/hiprt/${SLOT}"
	)

	if use cuda; then
		local -x CUDA_PATH="${ESYSROOT}/opt/cuda"
		local -x CUDA_PATH_V12_2="${ESYSROOT}/opt/cuda"

		mycmakeargs+=(
			-DFORCE_CUDA=ON
		)
	fi

	cmake_src_configure
}

src_test() {
	check_amdgpu

	if ! use cuda; then
		local -x GTEST_FILTER="-hiprtTest.CudaEnabled"
	fi

	pushd dist > /dev/null || die
	edo ./bin/$(usex debug Debug Release)/unittest64
	popd > /dev/null || die
}
