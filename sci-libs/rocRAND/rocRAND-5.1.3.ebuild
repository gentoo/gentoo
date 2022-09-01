# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
HIPRAND_COMMIT_HASH=de941a7eb9ede2a862d719cd3ca23234a3692d07
SRC_URI="https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
https://github.com/ROCmSoftwarePlatform/hipRAND/archive/${HIPRAND_COMMIT_HASH}.tar.gz -> hipRAND-${HIPRAND_COMMIT_HASH}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="benchmark test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="dev-util/hip"
DEPEND="${RDEPEND}
dev-util/rocm-cmake
test? ( dev-cpp/gtest )"
BDEPEND="dev-util/rocm-cmake
>=dev-util/cmake-3.22"

S="${WORKDIR}/rocRAND-rocm-${PV}"

src_prepare() {
	rmdir hipRAND || die
	mv -v ../hipRAND-${HIPRAND_COMMIT_HASH} hipRAND || die
	# change installed include and lib dir, and avoid symlink overwrite the installed headers
	# avoid setting RPATH
	sed -r -e "s:(hip|roc)rand/lib:\${CMAKE_INSTALL_LIBDIR}:" \
		-e "s:(hip|roc)rand/include:include/\1rand:" \
		-e '/\$\{INSTALL_SYMLINK_COMMAND\}/d' \
		-e "/INSTALL_RPATH/d" -i library/CMakeLists.txt || die

	# remove GIT dependency
	sed -e "/find_package(Git/,+4d" -i cmake/Dependencies.cmake || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_HIPRAND=ON
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
