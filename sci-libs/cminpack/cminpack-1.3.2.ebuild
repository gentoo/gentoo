# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="C implementation of the MINPACK nonlinear optimization library"
HOMEPAGE="http://devernay.free.fr/hacks/cminpack/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="minpack"
SLOT="0/${PV}"
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
