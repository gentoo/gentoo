# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/levmar/levmar-2.6.ebuild,v 1.1 2014/08/07 16:55:20 amynka Exp $

EAPI=5

inherit cmake-utils eutils toolchain-funcs

DESCRIPTION="Levenberg-Marquardt nonlinear least squares C library"
HOMEPAGE="http://www.ics.forth.gr/~lourakis/levmar/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-shared.patch
	"${FILESDIR}"/${P}-demo-underlinking.patch
)

src_configure() {
	local mycmakeargs+=(
		-DNEED_F2C=OFF
		-DHAVE_LAPACK=ON
		-DLAPACKBLAS_LIB_NAMES="$($(tc-getPKG_CONFIG) --libs blas lapack)"
		$(cmake-utils_use test BUILD_DEMO)
	)
	cmake-utils_src_configure
}

src_test() {
	cd ${CMAKE_BUILD_DIR}
	./lmdemo || die
}

src_install() {
	dolib.so ${CMAKE_BUILD_DIR}/liblevmar.so
	insinto /usr/include
	doins levmar.h
}
