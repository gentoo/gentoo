# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..15} )
ROCM_VERSION=${PV}

inherit cmake python-any-r1 rocm
DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblas"
SRC_URI="https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/hipblas.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hipblas"

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
BDEPEND="
	${PYTHON_DEPS}
	dev-build/rocm-cmake
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.3.0-no-git.patch
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
		# currently hipBLAS is a wrapper of rocBLAS which has tests, so no need to perform test here
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_WITH_SOLVER=$(usex rocsolver ON OFF)
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}
