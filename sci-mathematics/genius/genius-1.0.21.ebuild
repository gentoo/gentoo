# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Genius Mathematics Tool and the GEL Language"
HOMEPAGE="http://www.jirka.org/genius.html"
SRC_URI="${SRC_URI}
	doc? ( http://www.jirka.org/${PN}-reference.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome nls"

RDEPEND="
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-libs/popt
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	gnome? (
		x11-libs/gtk+:2
		gnome-base/libgnome
		gnome-base/libgnomeui
		gnome-base/libglade:2.0
		x11-libs/gtksourceview:2.0
		x11-libs/vte:0 )
"
DEPEND="${RDEPEND}
	app-text/rarian
	dev-util/gtk-update-icon-cache
	dev-util/intltool
	|| ( sys-devel/bison dev-util/yacc )
	sys-devel/flex
	app-text/gnome-doc-utils
	nls? ( sys-devel/gettext )
"

src_configure() {
	gnome2_src_configure \
		$(use_enable gnome) \
		$(use_enable nls) \
		--disable-extra-gcc-optimization \
		--disable-static
}

src_install() {
	use doc && DOCS+=" ${DISTDIR}/${PN}-reference.pdf"
	gnome2_src_install
}
