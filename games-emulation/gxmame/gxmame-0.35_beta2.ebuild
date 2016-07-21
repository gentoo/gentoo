# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_P="${PN}-${PV/_beta/beta}"
DESCRIPTION="frontend for XMame using the GTK library"
HOMEPAGE="http://gxmame.sourceforge.net/"
SRC_URI="mirror://sourceforge/gxmame/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls joystick"

RDEPEND="dev-libs/expat
	>=x11-libs/gtk+-2.4:2
	>=dev-libs/glib-2.4:2
	x11-themes/gnome-icon-theme
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glib-single-include.patch \
		"${FILESDIR}"/${P}-ovflfix.patch
	sed -i \
		-e "s:-O2 -fomit-frame-pointer -ffast-math:${CFLAGS}:" \
		-e "s:-O2:${CFLAGS}:" \
		configure || die
	sed -i \
		-e '/Icon/s/\.png//' \
		-e '/Categories/s/Application;//' \
		gxmame.desktop.in || die
	sed -i \
		-e 's:COPYING::' \
		-e "s:^docdir = .*:docdir = /usr/share/doc/${PF}:" \
		-e "s:^htmldir = .*:htmldir = /usr/share/doc/${PF}/html:" \
		-e "s:^icondir = .*:icondir = /usr/share/icons:" \
		-e "s:^pixmapdir = .*:pixmapdir = /usr/share/pixmaps:" \
		-e "s:^gnulocaledir = .*:gnulocaledir = /usr/share/locale:" \
		-e "s:^icon2dir = .*:icon2dir = /usr/share/icons/mini:" \
		-e "s:^Graphicsdir = .*:Graphicsdir = /usr/share/applications:" \
		-e "/DDATADIR/s:\$(datadir):/usr/share/pixmaps:" \
		-e "/DPACKAGE_LOCALE_DIR/s:\$(datadir):/usr/share:" \
		Makefile.in html/Makefile.in src/Makefile.in po/Makefile.in.in || die
	sed -i -e 's/"gxmame"/""/' src/gui.c || die
}

src_configure() {
	egamesconf \
		--with-xmame-dir="${GAMES_DATADIR}"/xmame \
		$(use_enable nls) \
		$(use_enable joystick)
}

src_install() {
	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO" \
		default
	prepgamesdirs
}
