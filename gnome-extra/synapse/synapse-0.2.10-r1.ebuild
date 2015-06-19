# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/synapse/synapse-0.2.10-r1.ebuild,v 1.1 2015/01/14 13:21:19 pacho Exp $

EAPI=5
GCONF_DEBUG="no" # gnome2_src_configure is not being used
AUTOTOOLS_AUTORECONF=true

inherit gnome2 autotools-utils vala

DESCRIPTION="A program launcher in the style of GNOME Do"
HOMEPAGE="http://launchpad.net/synapse-project/"
SRC_URI="http://launchpad.net/synapse-project/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# "ayatana" support pending on GTK+-3.x version of synapse wrt #411613
IUSE="plugins +zeitgeist"

RDEPEND="
	dev-libs/libgee:0.8
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

	# Don't crash on empty string (from Arch)
	"${FILESDIR}"/${PN}-0.2.10-check-null-exec.patch

	# XDG_CURRENT_DESKTOP fix (from Arch)
	"${FILESDIR}"/${PN}-0.2.10-fix-check-desktop.patch

	# Fix newer gnome support (from OpenSuSE)
	"${FILESDIR}"/${PN}-0.2.10-gnome-3.10.patch

	# Port to gee-0.8 (from Arch)
	"${FILESDIR}"/${PN}-0.2.10-libgee-0.8.patch

	# Fix border painting (from OpenSuSE)
	"${FILESDIR}"/${PN}-0.2.10-fix-border-painting.patch

	"${FILESDIR}"/${PN}-0.2.10-zeitgeist.patch
)

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
