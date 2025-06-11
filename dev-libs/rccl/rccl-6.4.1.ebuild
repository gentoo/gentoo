# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo rocm flag-o-matic

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCm/rccl"
SRC_URI="https://github.com/ROCm/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"
S="${WORKDIR}/rccl-rocm-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="roctracer test"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-util/rocm-smi:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs"
BDEPEND="
	>=dev-build/cmake-3.22
	>=dev-build/rocm-cmake-5.7.1
	dev-util/hipify-clang:${SLOT}
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-6.0.2-fix-version-check.patch"
	"${FILESDIR}/${PN}-6.1.1-headers-fix.patch"
)

src_prepare() {
	cmake_src_prepare

	# complete fix-version-check patch
	sed "s/@rocm_version@/${PV}/" -i CMakeLists.txt || die

	# don't install tests
	sed "/rocm_install(TARGETS rccl-UnitTests/d" -i test/CMakeLists.txt || die
}

src_configure() {
	rocm_use_hipcc

	# lto flags make compilation fail with "undefined hidden symbol"
	filter-lto

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-DROCM_PATH="${EPREFIX}/usr"
		-DRCCL_ROCPROFILER_REGISTER=OFF
		-DENABLE_MSCCLPP=OFF
		-DROCTX=$(usex roctracer ON OFF)
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# APU (as second device, if any) expectedly breaks tests
	HIP_VISIBLE_DEVICES=0 LD_LIBRARY_PATH="${BUILD_DIR}" edob test/rccl-UnitTests
}
