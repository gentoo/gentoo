# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/synapse/synapse-0.2.10.ebuild,v 1.9 2014/01/19 15:20:08 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true
VALA_MIN_API_VERSION=0.14
VALA_MAX_API_VERSION=0.20

inherit gnome2 autotools-utils gnome2-utils vala

DESCRIPTION="A program launcher in the style of GNOME Do"
HOMEPAGE="http://launchpad.net/synapse-project/"
SRC_URI="http://launchpad.net/synapse-project/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# "ayatana" support pending on GTK+-3.x version of synapse wrt #411613
IUSE="plugins +zeitgeist"

RDEPEND="
	dev-libs/libgee:0
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libunique:1
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtkhotkey
	x11-libs/gtk+:2
	x11-libs/libnotify
	x11-libs/pango
	x11-themes/gnome-icon-theme
	plugins? ( net-libs/rest )
	zeitgeist? (
		dev-libs/libzeitgeist
		gnome-extra/zeitgeist
		gnome-extra/zeitgeist-extensions
		|| ( gnome-extra/zeitgeist[fts] gnome-extra/zeitgeist-extensions[fts] )
		)"
	#ayatana? ( dev-libs/libappindicator )
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.8.2-underlinking.patch
	"${FILESDIR}"/${PN}-0.2.8.2-zeitgeist.patch
	)

pkg_preinst() {
	gnome2_icon_savelist
}

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

pkg_preinst() {
	gnome2_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
}
