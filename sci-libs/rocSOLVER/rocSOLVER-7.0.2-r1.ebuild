# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edo flag-o-matic rocm

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsolver"
SRC_URI="https://github.com/ROCm/rocSOLVER/archive/rocm-${PV}.tar.gz -> rocSOLVER-${PV}.tar.gz"
S=${WORKDIR}/${PN}-rocm-${PV}

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="benchmark sparse test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="
	dev-libs/libfmt:=
	dev-util/hip:${SLOT}
	sci-libs/rocBLAS:${SLOT}
	benchmark? ( sci-libs/flexiblas )
	sparse? ( sci-libs/rocSPARSE:${SLOT} )
"
DEPEND="
	${RDEPEND}
	sci-libs/rocPRIM:${SLOT}
"
BDEPEND="
	test? (
		dev-cpp/gtest
		sci-libs/flexiblas
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.1-fix-includes.patch
)

src_configure() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-Wno-dev
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_WITH_SPARSE=$(usex sparse ON OFF)
	)

	if use benchmark || use test; then
		mycmakeargs+=(
			-DROCSOLVER_FIND_PACKAGE_LAPACK_CONFIG=OFF
			-DBLA_PKGCONFIG_BLAS=ON
			-DBLA_VENDOR=FlexiBLAS
		)
	fi

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	# No filters: 64m28s on gfx1100
	# 'checkin*-*known_bug*': 1m35s
	HIP_VISIBLE_DEVICES=0 LD_LIBRARY_PATH="${BUILD_DIR}/library/src" \
		edob ./rocsolver-test \
		--gtest_filter='checkin*-*known_bug*:*GVD*batched*:*STEDCX*/74:*BDSVDX*:*SYGVDX_INPLACE.__float*'
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin clients/staging/rocsolver-bench
	fi
}
