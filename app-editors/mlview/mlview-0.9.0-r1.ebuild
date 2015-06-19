# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mlview/mlview-0.9.0-r1.ebuild,v 1.3 2014/12/30 12:21:39 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="XML editor for the GNOME environment"
HOMEPAGE="http://www.nongnu.org/mlview/mlview-internals.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	>=dev-libs/libxml2-2.6.11:2
	>=dev-libs/libxslt-1.1.8
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.6:2
	>=dev-cpp/gtkmm-2.4:2.4
	>=gnome-base/libglade-2.4:2.0
	>=dev-cpp/libglademm-2.6:2.4
	>=gnome-base/libgnome-2.8.1
	>=gnome-base/gnome-vfs-2.6:2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/gconf-2.6.2:2
	x11-libs/gtksourceview:2.0
	>=x11-libs/vte-0.11.12:0
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	DOCS="AUTHORS BRANCHES ChangeLog NEWS README"

	# Fix tests
	echo "ui/mlview-exec-command.glade" >> po/POTFILES.in || die
	echo "ui/mlview-plugins-window.glade" >> po/POTFILES.in || die

	epatch "${FILESDIR}"/${P}-desktop.patch
	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-gcc45.patch
	epatch "${FILESDIR}"/${PF}-10_port_to_gtksourceview2.patch
	epatch "${FILESDIR}"/${PF}-autoreconf.patch

	mkdir m4 || die
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable debug)
}
