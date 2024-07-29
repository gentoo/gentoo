# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake flag-o-matic rocm

DESCRIPTION="AMD ROCm Performance Primitives (RPP) high-performance computer vision library"
HOMEPAGE="https://github.com/ROCm/rpp"
SRC_URI="https://github.com/ROCm/rpp/archive/refs/tags/rocm-${PV}.tar.gz -> rpp-${PV}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

# pkgcheck warning: RequiredUseDefaults
REQUIRED_USE="
	cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_f16c
	${ROCM_REQUIRED_USE}
"

RDEPEND="
	dev-util/hip:${SLOT}
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/cmake-3.22
	>=dev-libs/half-1.12.0-r1
	test? (
		dev-cpp/gtest
		media-libs/opencv:=
	)
"

IUSE="cpu_flags_x86_avx2 cpu_flags_x86_fma3 cpu_flags_x86_f16c test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-skip-install-license.patch
)

DOCS=( CHANGELOG.md LICENSE README.md )

rcc_test_wrapper() {
	local S="${WORKDIR}/${PN}-rocm-${PV}/utilities/rpp-unittests/HIP_NEW"
	local CMAKE_USE_DIR="${S}"
	local BUILD_DIR="${BUILD_DIR}/utilities/rpp-unittests/HIP_NEW"
	cd "${S}" || die
	$@
}

src_prepare() {
	sed -e "s:\${ROCM_PATH}/llvm/bin/clang++:hipcc:" \
		-i CMakeLists.txt || die

	cmake_src_prepare
	if use test; then
		local PATCHES=()
		rcc_test_wrapper cmake_src_prepare
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCM_PATH=/usr
		-DBACKEND=HIP
		-DBUILD_WITH_AMD_ADVANCE=OFF
	)

	cmake_src_configure

	if use test; then
		append-cxxflags -I"${S}/include"
		append-ldflags -L"${BUILD_DIR}/lib64"
		local mycmakeargs=(-DROCM_PATH=/usr)
		use test && rcc_test_wrapper cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	use test && rcc_test_wrapper cmake_src_compile
}

src_test() {
	check_amdgpu

	cd "${BUILD_DIR}"/utilities/rpp-unittests/HIP_NEW || die
	for params in "0 0" "0 1" "1 1" "2 1" "5 1" "0 2" "0 3" "0 4" "0 5" "0 8"; do
		LD_LIBRARY_PATH="${BUILD_DIR}"/lib64 ./uniqueFunctionalities_hip $params || die
	done
}
