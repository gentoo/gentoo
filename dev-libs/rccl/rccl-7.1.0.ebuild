# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake edo rocm flag-o-matic

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCm/rccl"
SRC_URI="https://github.com/ROCm/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"
S="${WORKDIR}/rccl-rocm-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

# not supported on some GPUs like gfx1151
IUSE_TARGETS=( gfx906 gfx908 gfx90a gfx942 gfx950 gfx1030 gfx1100 gfx1101 gfx1102 gfx1200 gfx1201 )
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
ROCM_USEDEP_OPTFLAGS=${IUSE_TARGETS[*]/%/(-)?}
ROCM_USEDEP=${ROCM_USEDEP_OPTFLAGS// /,}
ROCM_REQUIRED_USE=" || ( ${IUSE_TARGETS[*]} )"

IUSE="${IUSE_TARGETS[*]/#/+} roctracer test"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-util/rocm-smi:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
	dev-libs/libfmt:=
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
	"${FILESDIR}/${PN}-7.0.1-fix-libcxx.patch"
)

src_prepare() {
	# don't install tests
	sed -e '/rocm_install(TARGETS rccl-UnitTests/d' -i test/CMakeLists.txt || die

	# cmake4 compatibility requiores cmake_minimum_required>=3.5
	sed -e '/cmake_minimum_required/ s/2\.8\.12/3.16/' -i test/CMakeLists.txt || die

	# too many warnings...
	sed -e '/target_compile_options(rccl PRIVATE -Wall)/d' -i CMakeLists.txt || die

	# allow to redefine CMAKE_INSTALL_LIBDIR from lib to $(get_libdir)
	sed -e '/CMAKE_INSTALL_LIBDIR/ s/ FORCE//' -i cmake/Dependencies.cmake || die
	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	# lto flags make compilation fail with "undefined hidden symbol"
	filter-lto

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-DROCM_PATH="${EPREFIX}/usr"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)"
		-DRCCL_ROCPROFILER_REGISTER=OFF
		-DENABLE_MSCCLPP=OFF
		-DROCTX=$(usex roctracer ON OFF)
		-DEXPLICIT_ROCM_VERSION="${PV}"
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
