# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cminpack/cminpack-1.3.4.ebuild,v 1.1 2014/06/09 02:43:41 bicatali Exp $

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="C implementation of the MINPACK nonlinear optimization library"
HOMEPAGE="http://devernay.free.fr/hacks/cminpack/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="minpack"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

PATCHES=( "${FILESDIR}"/${PN}-1.2.2-underlinking.patch )

src_configure() {
	sed -i \
		-e "/CMINPACK_LIB_INSTALL_DIR/s:lib\(\|64\):$(get_libdir):g" \
		cmake/cminpack_utils.cmake || die
	local mycmakeargs+=(
		-DSHARED_LIBS=ON
		$(cmake-utils_use_build test examples)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc readme*
	use doc && dohtml -A .txt doc/*
}
