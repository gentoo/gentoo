# Copyright 1999-2024 Gentoo Authors
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
IUSE="test"

RDEPEND="
	=dev-util/hip-6*
	dev-util/rocm-smi:${SLOT}"
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
)

src_prepare() {
	cmake_src_prepare

	# https://reviews.llvm.org/D69582 - clang does not support parallel jobs
	sed 's/-parallel-jobs=[0-9][0-9]//g' -i CMakeLists.txt || die

	# https://github.com/ROCm/rccl/issues/958 - fix AMDGPU_TARGETS
	sed '/set(AMDGPU_TARGETS/s/ FORCE//' -i CMakeLists.txt || die

	# complete fix-version-check patch
	sed "s/@rocm_version@/${PV}/" -i CMakeLists.txt || die
}

src_configure() {
	rocm_use_hipcc

	# https://github.com/llvm/llvm-project/issues/71711 - fix issue of clang
	append-ldflags -Wl,-z,noexecstack

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-Wno-dev
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	LD_LIBRARY_PATH="${BUILD_DIR}" edob test/rccl-UnitTests
}
