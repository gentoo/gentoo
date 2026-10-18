# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION=${PV}

inherit cmake edob flag-o-matic rocm toolchain-funcs

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsolver"

SRC_URI="
	https://github.com/ROCm/rocm-libraries/releases/download/therock-${PV%.0}/rocsolver.tar.gz
		-> rocsolver-${PV}.tar.gz
"
S="${WORKDIR}/rocsolver"

LICENSE="BSD-2 BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="benchmark sparse test"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

RDEPEND="
	dev-util/hip:${SLOT}
	sci-libs/rocBLAS:${SLOT}
	benchmark? ( sci-libs/flexiblas )
	sparse? ( sci-libs/rocSPARSE:${SLOT} )
"
DEPEND="
	${RDEPEND}
	dev-libs/libfmt:=
	sci-libs/rocPRIM:${SLOT}
"
BDEPEND="
	dev-build/rocm-cmake
	test? (
		dev-cpp/gtest
		sci-libs/flexiblas
	)
"

RESTRICT="!test? ( test )"

src_configure() {
	rocm_use_clang

	# too many warnings
	append-cxxflags -Wno-explicit-specialization-storage-class
	# test reference code asserts on singular matrices, upstream builds without asserts
	append-cppflags -DNDEBUG

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DROCM_SYMLINK_LIBS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=$(usex test ON OFF)
		-DBUILD_CLIENTS_BENCHMARKS=$(usex benchmark ON OFF)
		-DBUILD_WITH_SPARSE=$(usex sparse ON OFF)
		-Wno-dev
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
	# Tolerances assume reference LAPACK; with OpenBLAS SY2SB_HE2HB exceeds 10*eps
	local -x FLEXIBLAS=NETLIB
	local filter="checkin*-*known_bug*"
	# libc++ distributions generate other random matrices; with the fixed seed these
	# cases are borderline (eigenvalue at the interval edge, error near tolerance)
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		filter+=":checkin_lapack/BDSVDX.*/71:checkin_lapack/BDSVDX.*/162"
		filter+=":checkin_lapack/STEDCX.*/74:checkin_lapack/SYGVDJ.*double/32"
	fi
	HIP_VISIBLE_DEVICES=0 LD_LIBRARY_PATH="${BUILD_DIR}/library/src" \
		edob ./rocsolver-test --gtest_filter="${filter}"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dobin clients/staging/rocsolver-bench
	fi
}
