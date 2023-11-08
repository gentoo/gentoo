# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo rocm flag-o-matic

DESCRIPTION="ROCm Communication Collectives Library (RCCL)"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rccl"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rccl/archive/rocm-${PV}.tar.gz -> rccl-${PV}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"

RDEPEND="
	=dev-util/hip-5*
	dev-util/rocm-smi:${SLOT}"
DEPEND="${RDEPEND}
	sys-libs/binutils-libs"
BDEPEND="
	>=dev-build/cmake-3.22
	>=dev-build/rocm-cmake-5.0.2-r1
	dev-util/hipify-clang:${SLOT}
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"
S="${WORKDIR}/rccl-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-remove-chrpath.patch"
)

src_prepare() {
	cmake_src_prepare

	# https://reviews.llvm.org/D69582 - clang does not support parallel jobs
	sed -i 's/-parallel-jobs=[0-9][0-9]//g' CMakeLists.txt || die

	# https://github.com/ROCmSoftwarePlatform/rccl/pull/860 - bad escape
	sed -i 's/\\%/%/' src/include/msccl/msccl_struct.h || die

	# https://github.com/ROCmSoftwarePlatform/rccl/issues/958 - fix AMDGPU_TARGETS
	sed -i '/set(AMDGPU_TARGETS/s/ FORCE//' CMakeLists.txt || die
}

src_configure() {
	addpredict /dev/kfd
	addpredict /dev/dri/

	# https://github.com/llvm/llvm-project/issues/71711 - fix issue of clang
	append-ldflags -Wl,-z,noexecstack

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_TESTS=$(usex test ON OFF)
		-DROCM_SYMLINK_LIBS=OFF
		-Wno-dev
	)

	CXX=hipcc cmake_src_configure
}

src_test() {
	CHECK_AMDGPU
	LD_LIBRARY_PATH="${BUILD_DIR}" edob test/rccl-UnitTests
}

src_install() {
	cmake_src_install

	# remove extra copy of headers
	rm -r "${ED}"/usr/rccl || die
}
