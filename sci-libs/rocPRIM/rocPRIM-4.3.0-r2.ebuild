# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"

RDEPEND="dev-util/hip
	benchmark? ( dev-cpp/benchmark )"
BDEPEND="dev-util/rocm-cmake
	>=dev-util/cmake-3.22
	test? ( dev-cpp/gtest )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocPRIM-rocm-${PV}"

RESTRICT="!test? ( test )"

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
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
	)

	cmake_src_configure
}

src_test() {
	# Grant access to the device
	addwrite /dev/kfd
	addwrite /dev/dri/
	cmake_src_test
}
