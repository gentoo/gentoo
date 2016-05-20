# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2

DESCRIPTION="Genius Mathematics Tool and the GEL Language"
HOMEPAGE="http://www.jirka.org/genius.html"
SRC_URI="
	mirror://gnome/sources/${PN}/1.0/${P}.tar.xz
	doc? ( http://www.jirka.org/${PN}-reference.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0
	dev-libs/popt
	sys-libs/ncurses:0=
	sys-libs/readline:0
	gnome? (
		x11-libs/gtk+:2
		gnome-base/libgnome
		gnome-base/libgnomeui
		gnome-base/libglade:2.0
		x11-libs/gtksourceview:2.0
		x11-libs/vte:0 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	|| ( sys-devel/bison dev-util/yacc )
	sys-devel/flex
	app-text/scrollkeeper
	app-text/gnome-doc-utils
	nls? ( sys-devel/gettext )"

src_prepare() {
	G2CONF="${G2CONF} $(use_enable gnome) $(use_enable nls) \
		--disable-update-mimedb --disable-scrollkeeper \
		--disable-extra-gcc-optimization"
	# gnome2.eclass adds --disable-gtk-doc or --enable-gtk-doc to G2CONF
	# if there is the USE flag doc, thus leading to QA warnings
	GCONF_DEBUG="no"
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	USE_DESTDIR="1"

	epatch "${FILESDIR}"/${P}-gcc4.8.patch
}

src_install() {
	use doc && DOCS+=" ${DISTDIR}/${PN}-reference.pdf"
	gnome2_src_install
}
