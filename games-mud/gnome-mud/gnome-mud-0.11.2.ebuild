# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/gnome-mud/gnome-mud-0.11.2.ebuild,v 1.11 2015/02/14 02:45:03 mr_bones_ Exp $

EAPI=5
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 games

DESCRIPTION="GNOME MUD client"
HOMEPAGE="https://wiki.gnome.org/Apps/GnomeMud"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE="gstreamer"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2.0.1:2.0
	gnome-base/gconf:2
	>=x11-libs/vte-0.11:0
	gstreamer? ( media-libs/gstreamer:0.10 )
	dev-perl/XML-Parser
	dev-libs/libpcre
	net-libs/gnet:2
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.23
	>=sys-devel/gettext-0.11.5
	app-text/rarian"

src_configure() {
	gnome2_src_configure \
		--bindir="${GAMES_BINDIR}" \
		$(use_enable gstreamer)
}

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS PLUGIN.API README ROADMAP" \
		gnome2_src_install
	prepgamesdirs
}

pkg_preinst() {
	gnome2_pkg_preinst
	games_pkg_preinst
}

pkg_postinst() {
	gnome2_pkg_postinst
	games_pkg_postinst
	echo
	elog "For proper plugin operation, please create ~/.gnome-mud/plugins/"
	elog "if that directory doesn't already exist."
	elog "The command to do that is:"
	elog "    mkdir -p ~/.gnome-mud/plugins/"
	echo
}
