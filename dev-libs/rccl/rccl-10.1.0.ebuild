# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_SKIP_GLOBALS=1
inherit cmake edob rocm flag-o-matic

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCm/rocm-systems/tree/develop/projects/rccl"
SRC_URI="https://github.com/ROCm/rocm-systems/releases/download/therock-${PV%.0}/rccl.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rccl"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

# DEFAULT_GPUS from CMakeLists.txt
IUSE_TARGETS=(
	gfx906 gfx908 gfx90a gfx942 gfx950 gfx1030
	gfx1100 gfx1101 gfx1102 gfx1151 gfx1200 gfx1201
)
IUSE_TARGETS=( "${IUSE_TARGETS[@]/#/amdgpu_targets_}" )
ROCM_USEDEP_OPTFLAGS=${IUSE_TARGETS[*]/%/(-)?}
ROCM_USEDEP=${ROCM_USEDEP_OPTFLAGS// /,}
ROCM_REQUIRED_USE=" || ( ${IUSE_TARGETS[*]} )"

IUSE="${IUSE_TARGETS[*]/#/+} roctracer test"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="
	dev-libs/rocm-core:${SLOT}
	dev-util/hip:${SLOT}
	dev-util/amdsmi:${SLOT}
	roctracer? ( dev-util/roctracer:${SLOT} )
"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs
	dev-libs/libfmt:=
"
BDEPEND="
	dev-build/rocm-cmake:${SLOT}
	dev-util/hipify-clang:${SLOT}
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-no-roctx.patch
	"${FILESDIR}"/${P}-llvm-23-gfx942.patch
)

src_prepare() {
	# libstdc++ visibility workaround includes a libstdc++-internal header; <cstddef> includes
	# it with libstdc++ (__has_include does not help: clang's cuda_wrappers provide a wrapper)
	sed -e 's:^#include <bits/c++config.h>$:#include <cstddef>:' -i src/include/nccl_common.h || die
	# libc++ does not include <chrono> transitively
	sed -e "/#include <thread>/i #include <chrono>" -i test/common/TestBedChild.cpp || die
	# std::memcpy in a kernel resolves to the host function with libc++
	sed -e "s/std::memcpy(/__builtin_memcpy(/" -i test/device/TestOp128.cpp || die

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

src_install() {
	cmake_src_install

	# don't install tests
	if use test; then
		rm -r "${ED}"/usr/bin/{rccl,rccl-UnitTests*,librccl-test-profiler-stub.so} || die
	fi
}
