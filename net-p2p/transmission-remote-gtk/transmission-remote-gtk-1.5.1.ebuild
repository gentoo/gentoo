# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="GTK+ client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="https://github.com/transmission-remote-gtk/transmission-remote-gtk"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="appindicator debug geoip libproxy rss"

# RESTRICT="test"

# FIXME: bundles rss-glib-0.2.3
RDEPEND="
	>=dev-libs/glib-2.56:2
	>=dev-libs/json-glib-1.2.8
	net-misc/curl
	>=x11-libs/gtk+-3.22:3
	appindicator? ( dev-libs/libappindicator:3 )
	geoip? ( dev-libs/geoip )
	libproxy? ( net-libs/libproxy )
	rss? ( >=net-libs/libmrss-0.18 )
"
DEPEND="${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature rss mrss)
		$(meson_feature libproxy)
		$(meson_feature geoip)
		$(meson_feature appindicator libappindicator)
	)
	meson_src_configure
}
