# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

MY_PN=SuperLU_MT
SOVERSION=$(ver_cut 1)

DESCRIPTION="Multithreaded sparse LU factorization library"
HOMEPAGE="https://portal.nersc.gov/project/sparse/superlu/"
SRC_URI="https://github.com/xiaoyeli/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${SOVERSION}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc examples int64 openmp test threads"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( openmp threads )"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? ( app-shells/tcsh )"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-proto.patch
	"${FILESDIR}"/${P}-examples.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && ! use threads && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && ! use threads && tc-check-openmp
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLONGINT=$(usex int64)
		-Denable_examples=$(usex examples)
		-Denable_tests=$(usex test)
	)
	if use openmp && ! use threads; then
		mycmakeargs+=( -DPLAT=_OPENMP )
	else
		mycmakeargs+=( -DPLAT=_PTHREAD )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && dodoc DOC/ug.pdf
	if use examples; then
		docinto /examples
		dodoc -r EXAMPLE/*
	fi
}
