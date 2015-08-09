# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools-utils eutils

DESCRIPTION="A multi-lingual terminal emulator"
HOMEPAGE="http://mlterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/mlterm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="bidi cairo debug fcitx gtk ibus libssh2 m17n-lib nls regis scim static-libs uim utempter xft"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	bidi? ( dev-libs/fribidi )
	cairo? ( x11-libs/cairo )
	fcitx? ( app-i18n/fcitx )
	gtk? ( x11-libs/gtk+ )
	ibus? ( app-i18n/ibus )
	libssh2? ( net-libs/libssh2 )
	m17n-lib? ( dev-libs/m17n-lib )
	nls? ( virtual/libintl )
	regis? (
		|| (
			media-libs/sdl-ttf
			media-libs/sdl2-ttf
		)
	)
	scim? ( app-i18n/scim )
	uim? ( app-i18n/uim )
	utempter? ( sys-libs/libutempter )
	xft? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( ChangeLog README doc/{en,ja} )

AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

src_prepare() {
	# default config
	sed -i \
		-e "/ icon_path =/aicon_path = ${EPREFIX}/usr/share/pixmaps/mlterm-icon.svg" \
		-e "/ scrollbar_view_name =/ascrollbar_view_name = sample" \
		etc/main

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-type-engines=xcore$(usex xft ",xft" "")$(usex cairo ",cairo" "")
		--enable-optimize-redrawing
		--enable-vt52
		$(use_enable bidi fribidi)
		$(use_enable debug)
		$(use_enable fcitx)
		$(use_enable ibus)
		$(use_enable libssh2 ssh2)
		$(use_enable m17n-lib m17nlib)
		$(use_enable nls)
		$(use_enable scim)
		$(use_enable uim)
		$(use_enable utempter utmp)
	)

	local scrollbars="sample,extra"
	local tools="mlclient,mlcc,mlmenu,mlterm-zoom"
	if use gtk; then
		myeconfargs+=(--with-imagelib=gdk-pixbuf)
		if has_version x11-libs/gtk+:3; then
			myeconfargs+=(--with-gtk=3.0)
		else
			myeconfargs+=(--with-gtk=2.0)
		fi
		scrollbars+=",pixmap_engine"
		tools+=",mlconfig,mlimgloader"
	fi
	if use regis; then
		tools+=",registobmp"
	fi
	myeconfargs+=(--with-scrollbars="${scrollbars}")
	myeconfargs+=(--with-tools="${tools}")

	addpredict /dev/ptmx
	autotools-utils_src_configure
}

src_test() {
	:
}

src_install () {
	autotools-utils_src_install
	docinto contrib/icon
	dodoc contrib/icon/README

	doicon contrib/icon/mlterm*
	make_desktop_entry mlterm mlterm mlterm-icon "System;TerminalEmulator"
}
