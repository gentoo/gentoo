# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xaos/xaos-3.5-r1.ebuild,v 1.11 2014/06/09 18:43:33 bicatali Exp $

EAPI=4

inherit eutils autotools

DESCRIPTION="A very fast real-time fractal zoomer"
HOMEPAGE="http://xaos.sf.net/"
SRC_URI="
	http://dev.gentoo.org/~jlec/distfiles/${PN}.png.tar
	mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE="aalib doc -gtk nls png svga threads X"

RDEPEND="
	sci-libs/gsl
	sys-libs/zlib
	aalib? ( media-libs/aalib )
	gtk? ( x11-libs/gtk+:2 )
	png? ( media-libs/libpng )
	X? ( x11-libs/libX11
		 x11-libs/libXext
		 x11-libs/libXxf86vm )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	X? (
		x11-proto/xf86vidmodeproto
		x11-proto/xextproto
		x11-proto/xproto )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.4-png.patch \
		"${FILESDIR}"/${PN}-3.4-include.patch \
		"${FILESDIR}"/${PN}-3.5-libpng15.patch \
		"${FILESDIR}"/${PN}-3.5-build-fix-i686.patch \
		"${FILESDIR}"/${PN}-3.5-gettext.patch
	sed -i -e 's/-s//' Makefile.in
	eautoreconf
}

src_configure() {
	# use gsl and not nasm (see bug #233318)
	econf \
		--with-sffe=yes \
		--with-gsl=yes \
		$(use_enable nls) \
		$(use_with png) \
		$(use_with aalib aa-driver) \
		$(use_with gtk gtk-driver) \
		$(use_with threads pthread) \
		$(use_with X x11-driver) \
		$(use_with X x)
}

src_compile() {
	default
	if use doc; then
		cd "${S}"/doc
		emake xaos.dvi
		dvipdf xaos.dvi || die
		cd "${S}"/help
		emake html
	fi
}

src_install() {
	default
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/xaos.pdf
		dohtml -r help/*
	fi
	local driver="x11"
	use gtk && driver="\"GTK+ Driver\""
	make_desktop_entry "xaos -driver ${driver}" "XaoS Fractal Zoomer" \
		xaos "Application;Education;Math;Graphics;"
	doicon "${WORKDIR}"/${PN}.png
}
