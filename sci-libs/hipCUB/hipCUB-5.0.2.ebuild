# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Wrapper of rocPRIM or CUB for GPU parallel primitives"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip
	sci-libs/rocPRIM:${SLOT}
	benchmark? ( dev-cpp/benchmark )
	test? ( dev-cpp/gtest )
"
DEPEND="${RDEPEND}"

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
	)

	cmake_src_configure
}

src_test() {
	# Grant access to the device
	addwrite /dev/kfd
	addwrite /dev/dri/
	MAKEOPTS="-j1" cmake_src_test
}
