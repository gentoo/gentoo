# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="GTK client for MPD inspired by Rhythmbox but much lighter and faster"
HOMEPAGE="http://ario-player.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}-player/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug +idle nls taglib zeroconf"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2:2
	media-libs/libmpdclient
	net-misc/curl
	x11-libs/gtk+:3
	dbus? ( dev-libs/dbus-glib )
	taglib? ( media-libs/taglib )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS )

src_configure() {
	local myconf=(
		--disable-static
		--disable-xmms2
		--enable-libmpdclient2
		--enable-search
		--enable-playlists
		--disable-deprecations
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable idle mpdidle)
		$(use_enable nls)
		$(use_enable taglib)
		$(use_enable zeroconf avahi)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
