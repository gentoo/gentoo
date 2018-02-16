# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils fdo-mime gnome2-utils

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko lb lt mn nl nn pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="http://www.geany.org"
EGIT_REPO_URI="https://github.com/geany/geany.git"
inherit git-r3
SRC_URI=""
LICENSE="GPL-2+ HPND"
SLOT="0"

KEYWORDS=""
IUSE="gtk3 +vte"

RDEPEND=">=dev-libs/glib-2.32:2
	!gtk3? (
		>=x11-libs/gtk+-2.24:2
		vte? ( x11-libs/vte:0 )
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3
		vte? ( x11-libs/vte:2.91 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	default
	[[ ${PV} = *_pre* || ${PV} = 9999 ]] && eautoreconf
}
src_configure() {
	econf \
		--disable-html-docs \
		--disable-dependency-tracking \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable gtk3) \
		$(use_enable vte)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all
}

pkg_preinst() { gnome2_icon_savelist; }

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
