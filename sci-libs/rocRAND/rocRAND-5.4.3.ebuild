# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocRAND.git"
	S="${WORKDIR}/${P}"
else
	S="${WORKDIR}/${PN}-rocm-${PV}"
	HIPRAND_S="${WORKDIR}/hipRAND-rocm-${PV}"
	SRC_URI="https://github.com/ROCmSoftwarePlatform/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ROCmSoftwarePlatform/hipRAND/archive/refs/tags/rocm-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
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

src_prepare() {
	if [[ ${PV} != *9999 ]]; then
		rmdir hipRAND || die
		mv -v ${HIPRAND_S} hipRAND || die
	fi

	# remove GIT dependency
	sed -e "/find_package(Git/,+4d" -i cmake/Dependencies.cmake || die

	# do not install test files
	find "test" "hipRAND/test" -name "CMakeLists.txt" -print0 | \
		while IFS=  read -r -d '' filename; do
			sed '/rocm_install(/ {:r;/)/!{N;br}; s,.*,,}' -i ${filename} || die
		done

	eapply_user
	cmake_src_prepare
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DDISABLE_WERROR=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_HIPRAND=ON
		-DBUILD_FORTRAN_WRAPPER=OFF
		-DBUILD_TEST=$(usex test ON OFF)
		-DBUILD_BENCHMARK=$(usex benchmark ON OFF)
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	check_amdgpu
	export LD_LIBRARY_PATH="${BUILD_DIR}/library:${BUILD_DIR}/hipRAND/library"
	MAKEOPTS="-j1" cmake_src_test
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}"/benchmark
		dobin benchmark_rocrand_*
	fi
}
