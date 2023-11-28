# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz -> rocThrust-${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip
	sci-libs/rocPRIM:${SLOT}[${ROCM_USEDEP}]
	test? ( dev-cpp/gtest )"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/cmake-3.22"

S="${WORKDIR}/rocThrust-rocm-${PV}"

PATCHES=( "${FILESDIR}/${PN}-4.0-operator_new.patch" )

src_prepare() {
	sed -e "/PREFIX rocthrust/d" \
		-e "/DESTINATION/s:rocthrust/include/thrust:include/thrust:" \
		-e "/rocm_install_symlink_subdir(rocthrust)/d" \
		-e "/<INSTALL_INTERFACE/s:rocthrust/include/:include/:" -i thrust/CMakeLists.txt || die

	sed -e "s:\${CMAKE_INSTALL_INCLUDEDIR}:&/rocthrust:" \
		-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i cmake/ROCMExportTargetsHeaderOnly.cmake || die

	# disable downloading googletest and googlebenchmark
	sed  -r -e '/Downloading/{:a;N;/\n *\)$/!ba; d}' -i cmake/Dependencies.cmake || die

	# remove GIT dependency
	sed  -r -e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' -i cmake/Dependencies.cmake || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	# uses HMM to fit tests to default <512M iGPU VRAM
	MAKEOPTS="-j1" ROCTHRUST_USE_HMM="1" cmake_src_test
}

src_install() {
	cmake_src_install

	use benchmark && dobin "${BUILD_DIR}"/benchmarks/benchmark_thrust_bench
}
