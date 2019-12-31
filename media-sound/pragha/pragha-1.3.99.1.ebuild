# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A lightweight music player (for Xfce)"
HOMEPAGE="https://github.com/pragha-music-player/pragha"
SRC_URI="https://github.com/pragha-music-player/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cdda +glyr grilo +keybinder koel lastfm libnotify mtp +peas +playlist rygel soup +udev"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3=
	>=dev-libs/glib-2.42
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/taglib-1.8:=
	>=x11-libs/gtk+-3.14:3
	>=xfce-base/libxfce4ui-4.11:=[gtk3(+)]
	cdda? ( >=dev-libs/libcdio-0.90:=
		>=dev-libs/libcdio-paranoia-0.90:=
		>=media-libs/libcddb-1.3.0:= )
	glyr? ( >=media-libs/glyr-1.0.1:= )
	grilo? ( media-libs/grilo:0.3[network] )
	keybinder? ( >=dev-libs/keybinder-0.2.0:3 )
	koel? ( dev-libs/json-glib )
	lastfm? ( >=media-libs/libclastfm-0.5:= )
	libnotify? ( >=x11-libs/libnotify-0.7.5 )
	mtp? ( >=media-libs/libmtp-1.1.0:= )
	peas? ( >=dev-libs/libpeas-1.0.0[gtk] )
	playlist? ( >=dev-libs/totem-pl-parser-2.26:= )
	rygel? ( >=net-misc/rygel-0.26 )
	soup? ( >=net-libs/libsoup-2.38:= )
	udev? ( dev-libs/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.10
	sys-devel/gettext
	virtual/pkgconfig
	xfce-base/exo"
REQUIRED_USE="glyr? ( peas )
	grilo? ( peas )
	koel? ( soup )
	libnotify? ( peas )
	mtp? ( udev )
	rygel? ( peas )
	soup? ( peas )
	udev? ( peas )"

src_configure() {
	local myconf=(
		$(use_enable peas libpeas-1.0)
		$(use_enable glyr libglyr)
		$(use_enable lastfm libclastfm)
		$(use_enable cdda libcdio)
		$(use_enable cdda libcdio_paranoia)
		$(use_enable cdda libcddb)
		$(use_enable playlist totem-plparser)

		$(use_enable libnotify)
		$(use_enable keybinder)
		$(use_enable udev gudev-1.0)
		$(use_enable mtp libmtp)
		$(use_enable koel json-glib-1.0)
		$(use_enable soup libsoup-2.4)
		$(use_enable rygel rygel-server-2.6)
		$(use_enable grilo grilo-0.3)
		$(use_enable grilo grilo-net-0.3)
		# avoid trying to use 0.2 & 0.3 simultaneously
		# https://github.com/pragha-music-player/pragha/issues/124
		--disable-grilo-0.2
		--disable-grilo-net-0.2
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
