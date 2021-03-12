# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Levenberg-Marquardt nonlinear least squares C library"
HOMEPAGE="https://www.ics.forth.gr/~lourakis/levmar/"
SRC_URI="https://www.ics.forth.gr/~lourakis/levmar/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/blas
	virtual/lapack"
BDEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-demo-underlinking.patch
)

DOCS=(README.txt)

src_configure() {
	local mycmakeargs+=(
		-DNEED_F2C=OFF
		-DHAVE_LAPACK=ON
		-DLAPACKBLAS_LIB_NAMES="$($(tc-getPKG_CONFIG) --libs blas lapack)"
		-DBUILD_DEMO=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/lmdemo || die "Tests failed"
}

src_install() {
	dolib.so "${BUILD_DIR}"/liblevmar.so
	insinto /usr/include
	doins "${S}"/levmar.h
}
