# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="HIP back-end for the parallel algorithm library Thrust"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz -> rocThrust-${PV}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"

RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}
	sci-libs/rocPRIM:${SLOT}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocThrust-rocm-${PV}"

PATCHES=( "${FILESDIR}/${PN}-4.0-operator_new.patch"
	"${FILESDIR}/${P}-deprecate-hcc_detail.patch" )

src_prepare() {
	sed -e "/PREFIX rocthrust/d" \
		-e "/DESTINATION/s:rocthrust/include/thrust:include/rocthrust/thrust:" \
		-e "/rocm_install_symlink_subdir(rocthrust)/d" \
		-e "/<INSTALL_INTERFACE/s:rocthrust/include/:include/rocthrust/:" -i thrust/CMakeLists.txt || die

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
	# Grant access to the device
	addwrite /dev/kfd
	addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARKS=$(usex benchmark ON OFF)
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

src_install() {
	cmake_src_install

	use benchmark && dobin "${BUILD_DIR}"/benchmarks/benchmark_thrust_bench
}
