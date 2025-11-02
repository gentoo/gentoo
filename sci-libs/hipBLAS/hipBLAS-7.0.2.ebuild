# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake rocm
DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblas"
SRC_URI="https://github.com/ROCm/hipBLAS/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hipBLAS-rocm-${PV}"

REQUIRED_USE="${ROCM_REQUIRED_USE}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="rocsolver"

RDEPEND="
	sci-libs/rocBLAS:${SLOT}
	rocsolver? ( sci-libs/rocSOLVER:${SLOT} )
"
DEPEND="
	dev-util/hip:${SLOT}
	sci-libs/hipBLAS-common:${SLOT}
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.3.0-no-git.patch
)

src_configure() {
	rocm_use_clang

	local mycmakeargs=(
		# currently hipBLAS is a wrapper of rocBLAS which has tests, so no need to perform test here
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_WITH_SOLVER=$(usex rocsolver ON OFF)
	)

	cmake_src_configure
}
