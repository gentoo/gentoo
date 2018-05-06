# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
# I don't want gnome2 eclass
inherit autotools eutils gnome2-utils xdg-utils

DESCRIPTION="Quark is the Anti-GUI Music Player with a cool Docklet!"
HOMEPAGE="https://hsgg.github.com/quark/"
SRC_URI="https://hsgg.github.com/${PN}/${P}.tar.gz"

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
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	use gnome && gnome2_schemas_update
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
