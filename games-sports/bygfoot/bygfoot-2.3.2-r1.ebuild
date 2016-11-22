# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="GTK+2 Soccer Management Game"
HOMEPAGE="http://bygfoot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	app-arch/zip
	media-libs/freetype:2
	x11-libs/gtk+:2
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default

	sed -i \
		-e 's:$(gnulocaledir):/usr/share/locale:' \
		-e '/PACKAGE_LOCALE_DIR/s:\$(prefix)/\$(DATADIRNAME):/usr/share:' \
		-e '/bygfoot_LDADD/s/$/ -lm/' \
		po/Makefile.in.in src/Makefile.in || die
}

src_configure() {
	econf --disable-gstreamer
}

src_install() {
	emake DESTDIR="${D}" install
	esvn_clean "${D}"
	dodoc AUTHORS ChangeLog README TODO UPDATE
	newicon support_files/pixmaps/bygfoot_icon.png ${PN}.png
	make_desktop_entry ${PN} Bygfoot
}
