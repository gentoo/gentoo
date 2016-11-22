# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="GNOME MUD client"
HOMEPAGE="https://wiki.gnome.org/Apps/GnomeMud"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="gstreamer"

RDEPEND="virtual/libintl
	dev-libs/libpcre
	dev-perl/XML-Parser
	gnome-base/gconf:2
	>=gnome-base/libglade-2.0.1:2.0
	gstreamer? ( media-libs/gstreamer:0.10 )
	net-libs/gnet:2
	x11-libs/gtk+:2
	>=x11-libs/vte-0.11:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-text/rarian
	>=dev-util/intltool-0.23
	>=sys-devel/gettext-0.11.5"

src_configure() {
	gnome2_src_configure \
		$(use_enable gstreamer)
}

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS PLUGIN.API README ROADMAP" \
		gnome2_src_install
}

pkg_preinst() {
	gnome2_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	elog "For proper plugin operation, please create ~/.gnome-mud/plugins/"
	elog "if that directory doesn't already exist."
	elog "The command to do that is:"
	elog "    mkdir -p ~/.gnome-mud/plugins/"
	echo
}
