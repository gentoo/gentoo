# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A thin wrapper library on top of rocPRIM or CUB"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocPRIM:${SLOT}
	benchmark? ( dev-cpp/benchmark )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/hipCUB-rocm-${PV}"

PATCHES="${FILESDIR}/${PN}-4.3.0-add-memory-header.patch"

src_prepare() {
	sed -e "/PREFIX hipcub/d" \
		-e "/DESTINATION/s:hipcub/include/:include/:" \
		-e "/rocm_install_symlink_subdir(hipcub)/d" \
		-e "/<INSTALL_INTERFACE/s:hipcub/include/:include/hipcub/:" -i hipcub/CMakeLists.txt || die

	sed	-e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i cmake/ROCMExportTargetsHeaderOnly.cmake || die

	# disable downloading googletest and googlebenchmark
	sed  -r -e '/Downloading/{:a;N;/\n *\)$/!ba; d}' -i cmake/Dependencies.cmake || die

	# remove GIT dependency
	sed  -r -e '/find_package\(Git/{:a;N;/\nendif/!ba; d}' -i cmake/Dependencies.cmake || die

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
		-D__skip_rocmclang="ON" ## fix cmake-3.21 configuration issue caused by officialy support programming language "HIP"
	)

	cmake_src_configure
}

src_test() {
	# Grant access to the device
	addwrite /dev/kfd
	addwrite /dev/dri/
	cmake_src_test
}
