# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-${PV}.tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip:${SLOT}"
DEPEND="${RDEPEND}
>=dev-util/rocm-cmake-${PV}"
BDEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/rocRAND-rocm-${PV}"

src_prepare() {
	sed -r -e "s:(hip|roc)rand/lib:\${CMAKE_INSTALL_LIBDIR}:" \
		-e "s:(hip|roc)rand/include:include/\1rand:" \
		-e "/INSTALL_RPATH/d" -i library/CMakeLists.txt || die

	# remove GIT dependency
	sed -e "/find_package(Git/,+4d" -i cmake/Dependencies.cmake || die

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
		-DCMAKE_SKIP_RPATH=TRUE
		${AMDGPU_TARGETS+-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"}
		-D__skip_rocmclang="ON" ## fix cmake-3.21 configuration issue caused by officialy support programming language "HIP"
	)

	cmake_src_configure
	# do not rerun cmake and the build process in src_install
	sed '/RERUN/,+1d' -i "${BUILD_DIR}"/build.ninja || die
}

src_test() {
	# Grant access to the device
	addwrite /dev/kfd
	addwrite /dev/dri/
	cmake_src_test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}"/benchmark
		dobin benchmark_rocrand_*
	fi
}
