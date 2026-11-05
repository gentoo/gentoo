# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm

DESCRIPTION="CU / ROCM agnostic marshalling library for LAPACK routines on the GPU"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsolver"
SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/hipsolver.tar.gz
		-> hipsolver-${PV}.tar.gz
"
S="${WORKDIR}/hipsolver"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="sparse"

RESTRICT="test"

RDEPEND="
	dev-util/hip:${SLOT}
	sci-libs/rocSOLVER:${SLOT}
	sci-libs/rocBLAS:${SLOT}
	virtual/blas
	virtual/lapack
	sparse? (
		sci-libs/suitesparseconfig
		sci-libs/rocSPARSE:${SLOT}
		sci-libs/cholmod:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-build/rocm-cmake"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.1-find-cholmod.patch
)

src_prepare() {
	# libc++ does not include <new> transitively
	sed -e "/#include <exception>/a #include <new>" \
		-i library/src/include/exceptions.hpp || die

	cmake_src_prepare
}

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_WITH_SPARSE=$(usex sparse ON OFF)
		# geev uses CPU LAPACK; don't download and build OpenBLAS
		-DHIPSOLVER_INTERNAL_LAPACK_BUILD=OFF
		-DHIPSOLVER_FIND_PACKAGE_LAPACK_CONFIG=OFF
		-DBLA_VENDOR=Generic
	)

	cmake_src_configure
}
