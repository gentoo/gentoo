# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="A multi-lingual terminal emulator"
HOMEPAGE="http://mlterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/mlterm/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="bidi cairo canna debug fcitx freewnn gtk ibus libssh2 m17n-lib nls regis scim static-libs uim utempter xft"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	bidi? ( dev-libs/fribidi )
	cairo? ( x11-libs/cairo[X] )
	canna? ( app-i18n/canna )
	fcitx? ( app-i18n/fcitx )
	freewnn? ( app-i18n/freewnn )
	gtk? ( >=x11-libs/gtk+-2:= )
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

src_prepare() {
	# default config
	sed -i \
		-e "/ icon_path =/aicon_path = ${EPREFIX}/usr/share/pixmaps/mlterm-icon.svg" \
		-e "/ scrollbar_view_name =/ascrollbar_view_name = sample" \
		etc/main

	epatch_user
}

src_configure() {
	local myconf=(
		--disable-static
		--with-type-engines=xcore$(usex xft ",xft" "")$(usex cairo ",cairo" "")
		--enable-optimize-redrawing
		--enable-vt52
		$(use_enable bidi fribidi)
		$(use_enable canna)
		$(use_enable debug)
		$(use_enable fcitx)
		$(use_enable freewnn wnn)
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
		myconf+=(--with-imagelib=gdk-pixbuf)
		if has_version x11-libs/gtk+:3; then
			myconf+=(--with-gtk=3.0)
		else
			myconf+=(--with-gtk=2.0)
		fi
		scrollbars+=",pixmap_engine"
		tools+=",mlconfig,mlimgloader"
	fi
	if use regis; then
		tools+=",registobmp"
	fi
	myconf+=(--with-scrollbars="${scrollbars}")
	myconf+=(--with-tools="${tools}")

	addpredict /dev/ptmx
	econf "${myconf[@]}"
}

src_test() {
	:
}

src_install () {
	default
	dodoc -r doc/{en,ja}
	prune_libtool_files

	docinto contrib/icon
	dodoc contrib/icon/README

	doicon contrib/icon/mlterm*
	make_desktop_entry mlterm mlterm mlterm-icon "System;TerminalEmulator"
}
