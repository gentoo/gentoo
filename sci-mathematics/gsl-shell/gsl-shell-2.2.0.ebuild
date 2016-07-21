# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Lua interactive shell for sci-libs/gsl"
HOMEPAGE="http://www.nongnu.org/gsl-shell/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="doc fox"

RDEPEND="
	>=sci-libs/gsl-1.14
	virtual/blas
	>=x11-libs/agg-2.5
	>=media-libs/freetype-2.4.10
	sys-libs/readline
	|| ( media-fonts/ubuntu-font-family media-fonts/freefont media-fonts/dejavu )
	fox? ( x11-libs/fox:1.6 )"
DEPEND="${DEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx[latex] )"

S="${WORKDIR}"/${PN}

src_prepare() {
	tc-export PKG_CONFIG
	epatch \
		"${FILESDIR}"/${PN}-font.patch \
		"${FILESDIR}"/${PN}-strip.patch \
		"${FILESDIR}"/${PN}-usr.patch \
		"${FILESDIR}"/${P}-pkg-config.patch
	use fox || epatch "${FILESDIR}"/${PN}-nogui.patch
}

src_compile() {
	local BLAS=$($(tc-getPKG_CONFIG) --libs blas)

	if use fox; then
		local FOX_INCLUDES=`WANT_FOX=1.6 fox-config --cflags`
		local FOX_LIBS=`WANT_FOX=1.6 fox-config --libs`
		emake -j1 CFLAGS="${CFLAGS}" GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}" \
			FOX_INCLUDES="${FOX_INCLUDES}" FOX_LIBS="${FOX_LIBS}"
	else
		emake -j1 CFLAGS="${CFLAGS}" GSL_LIBS="$($(tc-getPKG_CONFIG) --libs gsl) ${BLAS}"
	fi

	if use doc; then
		pushd doc/user-manual > /dev/null
		emake -j1 html
		popd > /dev/null
	fi
}

src_install() {
	default
	use doc && dohtml -r doc/user-manual/_build/html/*
}
