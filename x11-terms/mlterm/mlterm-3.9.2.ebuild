# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit desktop

DESCRIPTION="A multi-lingual terminal emulator"
HOMEPAGE="http://mlterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"
IUSE="+X bidi brltty cairo debug fbcon fcitx freewnn gtk harfbuzz ibus libssh2 m17n-lib nls regis scim skk static-libs uim utempter wayland xft"
REQUIRED_USE="|| ( X fbcon wayland )"

RDEPEND="virtual/libcrypt:=
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
	)
	bidi? ( dev-libs/fribidi )
	brltty? ( app-accessibility/brltty[api(+)] )
	cairo? ( x11-libs/cairo[X(+)] )
	fbcon? ( media-fonts/unifont )
	fcitx? ( app-i18n/fcitx )
	freewnn? ( app-i18n/freewnn )
	gtk? ( x11-libs/gtk+:3 )
	harfbuzz? ( media-libs/harfbuzz[truetype(+)] )
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
	skk? (
		|| (
			virtual/skkserv
			app-i18n/skk-jisyo
		)
	)
	uim? ( app-i18n/uim )
	utempter? ( sys-libs/libutempter )
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
	)
	xft? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-font.patch )
DOCS=( doc/{en,ja} )

src_prepare() {
	# default config
	sed -i \
		-e "/ icon_path =/aicon_path = ${EPREFIX}/usr/share/pixmaps/${PN}-icon.svg" \
		-e "/ scrollbar_view_name =/ascrollbar_view_name = sample" \
		etc/main

	default
}

src_configure() {
	local myconf=(
		$(use_enable bidi fribidi)
		$(use_enable brltty brlapi)
		$(use_enable debug)
		$(use_enable fcitx)
		$(use_enable freewnn wnn)
		$(use_enable harfbuzz otl)
		$(use_enable ibus)
		$(use_enable libssh2 ssh2)
		$(use_enable m17n-lib m17nlib)
		$(use_enable nls)
		$(use_enable scim)
		$(use_enable skk)
		$(use_enable uim)
		$(use_with X x)
		--with-gui=$(usex X "xlib" "")$(usex fbcon ",fb" "")$(usex wayland ",wayland" "")
		--with-type-engines=xcore$(usex xft ",xft" "")$(usex cairo ",cairo" "")
		--with-utmp=$(usex utempter utempter none)
		--enable-optimize-redrawing
		--enable-vt52
		--disable-canna
		--disable-static
	)

	local scrollbars="sample,extra"
	local tools="mlclient,mlcc,mlfc,mlmenu,${PN}-zoom"
	if use gtk; then
		myconf+=(
			--with-gtk=3.0
			--with-imagelib=gdk-pixbuf
		)
		scrollbars+=",pixmap_engine"
		tools+=",mlconfig,mlimgloader"
	else
		myconf+=( --without-gtk )
	fi
	if use regis; then
		tools+=",registobmp"
	fi
	myconf+=( --with-scrollbars="${scrollbars}" )
	myconf+=( --with-tools="${tools}" )

	addpredict /dev/ptmx
	econf "${myconf[@]}"
}

src_test() {
	:
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	docinto contrib/icon
	dodoc contrib/icon/README

	doicon contrib/icon/${PN}*
	make_desktop_entry ${PN} ${PN} ${PN}-icon "System;TerminalEmulator"
}
