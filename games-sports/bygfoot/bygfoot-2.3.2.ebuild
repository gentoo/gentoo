# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/bygfoot/bygfoot-2.3.2.ebuild,v 1.7 2014/01/13 00:57:23 mr_bones_ Exp $

EAPI=5
inherit eutils games

DESCRIPTION="GTK+2 Soccer Management Game"
HOMEPAGE="http://bygfoot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/freetype:2
	app-arch/zip
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	sed -i \
		-e 's:$(gnulocaledir):/usr/share/locale:' \
		-e '/PACKAGE_LOCALE_DIR/s:\$(prefix)/\$(DATADIRNAME):/usr/share:' \
		-e '/bygfoot_LDADD/s/$/ -lm/' \
		po/Makefile.in.in src/Makefile.in || die
}

src_configure() {
	egamesconf --disable-gstreamer
}

src_install() {
	emake DESTDIR="${D}" install
	esvn_clean "${D}"
	dodoc AUTHORS ChangeLog README TODO UPDATE
	newicon support_files/pixmaps/bygfoot_icon.png ${PN}.png
	make_desktop_entry ${PN} Bygfoot
	prepgamesdirs
}
