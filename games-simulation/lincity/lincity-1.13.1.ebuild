# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/lincity/lincity-1.13.1.ebuild,v 1.4 2013/09/25 17:20:10 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="city/country simulation game for X and Linux SVGALib"
HOMEPAGE="http://lincity.sourceforge.net/"
SRC_URI="mirror://sourceforge/lincity/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls"

# dep fix (bug #82318)
RDEPEND="media-libs/libpng:0
	x11-libs/libXext
	x11-libs/libSM
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e '/^localedir/s:$(datadir):/usr/share:' \
		po/Makefile.in.in \
		intl/Makefile.in \
		|| die 'sed failed'
}

src_configure() {
	egamesconf \
		--with-gzip \
		$(use_enable nls) \
		--with-x
}

src_compile() {
	# build system logic is severely broken
	emake
	emake X_PROGS
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc Acknowledgements CHANGES README* TODO
	make_desktop_entry xlincity Lincity
	dogamesbin xlincity
	prepgamesdirs
}
