# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-5.4.2_stdint-gcc13.patch )

RDEPEND="dev-util/hip"
DEPEND="${RDEPEND}
dev-util/rocm-cmake
test? ( dev-cpp/gtest )"
BDEPEND="dev-util/rocm-cmake
>=dev-util/cmake-3.22"

S="${WORKDIR}/rocRAND-rocm-${PV}"

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_HIPRAND=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/library"
	MAKEOPTS="-j1" cmake_src_test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}"/benchmark
		dobin benchmark_rocrand_*
	fi
}
