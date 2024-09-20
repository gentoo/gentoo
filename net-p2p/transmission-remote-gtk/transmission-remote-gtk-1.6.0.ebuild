# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="GTK+ client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="https://github.com/transmission-remote-gtk/transmission-remote-gtk"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="appindicator geoip"

# RESTRICT="test"

# FIXME: bundles rss-glib-0.2.3
RDEPEND="
	net-libs/libsoup:3.0
	>=dev-libs/glib-2.70:2
	>=dev-libs/json-glib-1.2.8
	>=x11-libs/gtk+-3.22:3
	appindicator? ( dev-libs/libayatana-appindicator )
	geoip? ( dev-libs/geoip )
"
DEPEND="${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature geoip)
		$(meson_feature appindicator libappindicator)
	)
	meson_src_configure
}
