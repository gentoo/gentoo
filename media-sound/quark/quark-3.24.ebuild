# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quark/quark-3.24.ebuild,v 1.4 2012/10/04 21:40:11 ranger Exp $

EAPI=4
# I don't want gnome2 eclass
inherit autotools eutils fdo-mime gnome2-utils

DESCRIPTION="Quark is the Anti-GUI Music Player with a cool Docklet!"
HOMEPAGE="http://hsgg.github.com/quark/"
SRC_URI="http://hsgg.github.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnome"

RDEPEND="dev-libs/glib:2
	gnome-base/gnome-vfs:2
	media-libs/xine-lib
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	gnome? ( gnome-base/gconf:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS README"

src_prepare() {
	# sandbox violations
	gnome2_environment_reset
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	# fix underlinking wrt #367859
	# remove DEPRECATED flags wrt #387823
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	# debug switch only provides cflags
	econf \
		--disable-debug \
		--with-icondir=/usr/share/icons/hicolor/48x48/apps \
		$(use_enable gnome gconf)
}

pkg_preinst() {
	use gnome && gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	if use gnome ; then
		gnome2_gconf_install
		gnome2_schemas_update
	fi
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	use gnome && gnome2_schemas_update
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
