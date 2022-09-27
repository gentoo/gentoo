# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala xdg

DESCRIPTION="A program launcher in the style of GNOME Do"
HOMEPAGE="https://launchpad.net/synapse-project/"
SRC_URI="https://launchpad.net/synapse-project/0.3/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="appindicator nls plugins"

RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0.0:3
	dev-libs/json-glib
	dev-libs/keybinder:3
	dev-libs/libgee:0.8
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libnotify
	x11-libs/pango
	x11-themes/adwaita-icon-theme
	appindicator? ( dev-libs/libappindicator:3 )
	nls? ( virtual/libintl )
	plugins? ( >=net-libs/rest-0.7:0.7 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e 's/GNOME/GNOME;GTK/' data/synapse.desktop.in || die
	vala_src_prepare
}

src_configure() {
	econf \
		$(use_enable appindicator indicator) \
		$(use_enable nls) \
		$(use_enable plugins librest yes) \
		--disable-zeitgeist
}
