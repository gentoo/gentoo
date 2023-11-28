# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Wrapper of rocPRIM or CUB for GPU parallel primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip
	sci-libs/rocPRIM:${SLOT}[${ROCM_USEDEP}]
	benchmark? ( dev-cpp/benchmark )
	test? ( dev-cpp/gtest )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/hipCUB-rocm-${PV}"

# src_prepare() {
# 	sed -e "/PREFIX hipcub/d" \
# 		-e "/DESTINATION/s:hipcub/include/:include/:" \
# 		-e "/rocm_install_symlink_subdir(hipcub)/d" \
# 		-e "/<INSTALL_INTERFACE/s:hipcub/include/:include/hipcub/:" -i hipcub/CMakeLists.txt || die

# 	sed	-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i cmake/ROCMExportTargetsHeaderOnly.cmake || die

# 	# disable downloading googletest and googlebenchmark
# 	sed  -r -e '/Downloading/{:a;N;/\n *\)$/!ba; d}' -i cmake/Dependencies.cmake || die

# 	# remove GIT dependency
# 	sed  -r -e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' -i cmake/Dependencies.cmake || die

# 	if use benchmark; then
# 		sed -e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
# 			-e "/add_executable/a\  install(TARGETS \${BENCHMARK_TARGET})" -i benchmark/CMakeLists.txt || die
# 	fi

# 	eapply_user
# 	cmake_src_prepare
# }

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	# uses HMM to fit tests to default <512M iGPU VRAM
	MAKEOPTS="-j1" HIPCUB_USE_HMM="1" cmake_src_test
}
