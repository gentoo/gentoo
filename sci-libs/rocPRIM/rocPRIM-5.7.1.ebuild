# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}
inherit cmake rocm

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="dev-util/hip
	benchmark? ( dev-cpp/benchmark )
	test? ( dev-cpp/gtest )"
BDEPEND="dev-util/rocm-cmake
	>=dev-util/cmake-3.22"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocPRIM-rocm-${PV}"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/${PN}-5.7.1-expand-isa-compatibility.patch )

src_prepare() {
	# "hcc" is depcreated, new platform ist "rocclr"
	sed -e "/HIP_PLATFORM STREQUAL/s,hcc,rocclr," -i cmake/VerifyCompiler.cmake || die

	# Install according to FHS
	sed -e "/PREFIX rocprim/d" \
		-e "/INSTALL_INTERFACE/s,rocprim/include,include/rocprim," \
		-e "/DESTINATION/s,rocprim/include,include," \
		-e "/rocm_install_symlink_subdir(rocprim)/d" \
		-i rocprim/CMakeLists.txt || die

	# disable downloading googletest and googlebenchmark
	sed  -r -e '/Downloading/{:a;N;/\n *\)$/!ba; d}' -i cmake/Dependencies.cmake || die

	# remove GIT dependency
	sed  -r -e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' -i cmake/Dependencies.cmake || die

	# install benchmark files
	if use benchmark; then
		sed -e "/get_filename_component/s,\${BENCHMARK_SOURCE},${PN}_\${BENCHMARK_SOURCE}," \
			-e "/add_executable/a\  install(TARGETS \${BENCHMARK_TARGET})" -i benchmark/CMakeLists.txt || die
	fi

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
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	# uses HMM to fit tests to default <512M iGPU VRAM
	MAKEOPTS="-j1" ROCPRIM_USE_HMM="1" cmake_src_test
}
