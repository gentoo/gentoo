# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG="no" # gnome2_src_configure is not being used
AUTOTOOLS_AUTORECONF=true

inherit gnome2 autotools-utils vala

DESCRIPTION="A program launcher in the style of GNOME Do"
HOMEPAGE="https://launchpad.net/synapse-project/"
SRC_URI="https://launchpad.net/synapse-project/0.3/${PV}/+download/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# "ayatana" support pending on GTK+-3.x version of synapse wrt #411613
IUSE="plugins +zeitgeist"

RDEPEND="
	dev-libs/libgee:0.8
	>=dev-libs/glib-2.28.0:2
	dev-libs/json-glib
	dev-libs/keybinder:3
	dev-libs/libunique:1
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtkhotkey
	>=x11-libs/gtk+-3.0.0:3
	x11-libs/libnotify
	x11-libs/pango
	x11-themes/gnome-icon-theme
	plugins? ( >=net-libs/rest-0.7 )
	zeitgeist? (
		dev-libs/libzeitgeist
		>=gnome-extra/zeitgeist-0.9.14[fts]
		)"
	#ayatana? ( dev-libs/libappindicator )
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's/GNOME/GNOME;GTK/' data/synapse.desktop.in || die
	vala_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-indicator=no
		$(use_enable plugins librest yes)
		$(use_enable zeitgeist)
		)
	autotools-utils_src_configure
}
