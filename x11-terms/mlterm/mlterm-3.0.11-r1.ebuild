# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit autotools eutils

IUSE="bidi debug gtk ibus libssh2 m17n-lib nls scim static-libs uim xft"

DESCRIPTION="A multi-lingual terminal emulator"
HOMEPAGE="http://mlterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/mlterm/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
LICENSE="BSD"

RDEPEND="|| ( sys-libs/libutempter sys-apps/utempter )
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	gtk? ( x11-libs/gtk+:2 )
	xft? ( x11-libs/libXft )
	bidi? ( >=dev-libs/fribidi-0.10.4 )
	ibus? ( >=app-i18n/ibus-1.3 )
	libssh2? ( net-libs/libssh2 )
	nls? ( virtual/libintl )
	uim? ( >=app-i18n/uim-1.0 )
	scim? ( >=app-i18n/scim-1.4 )
	m17n-lib? ( >=dev-libs/m17n-lib-1.2.0 )"
#	vte? ( x11-libs/vte )
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.9.4-uim15-fix.patch \
		"${FILESDIR}"/${PN}-3.0.5-ibus.patch \
		"${FILESDIR}"/${PN}-3.0.7-underlinking.patch

	eautoconf
}

src_configure() {
	local myconf

	if use gtk ; then
		myconf="${myconf} --with-imagelib=gdk-pixbuf"
	else
		myconf="${myconf} --with-tools=mlclient,mlcc"
	fi

	if use xft ; then
		myconf="${myconf} --with-type-engines=xft"
	else
		myconf="${myconf} --with-type-engines=xcore"
	fi

	# iiimf isn't stable enough
	#myconf="${myconf} $(use_enable iiimf)"

	econf --enable-utmp \
		$(use_enable bidi fribidi) \
		$(use_enable debug) \
		$(use_enable ibus) \
		$(use_enable libssh2 ssh2) \
		$(use_enable nls) \
		$(use_enable uim) \
		$(use_enable scim) \
		$(use_enable m17n-lib m17nlib) \
		$(use_enable static-libs static) \
		${myconf} || die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die

	if ! use static-libs ; then
		find "${ED}" -name '*.la' -delete || die
	fi

	doicon contrib/icon/mlterm* || die
	make_desktop_entry mlterm mlterm mlterm-icon "System;TerminalEmulator" || die

	dodoc ChangeLog README || die

	docinto ja
	dodoc doc/ja/* || die
	docinto en
	dodoc doc/en/* || die
}
