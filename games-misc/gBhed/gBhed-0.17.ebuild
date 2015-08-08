# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="An Al Bhed translator"
HOMEPAGE="http://liquidchile.net/software/gbhed/"
SRC_URI="http://liquidchile.net/software/gbhed/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk"

DEPEND="gtk? ( x11-libs/gtk+:2 )"

src_prepare() {
	sed -i 's/19/32/' src/gui/translation_fork.c || die
}

src_configure() {
	egamesconf \
		--datadir="${GAMES_DATADIR}"/${PN} \
		$(use_enable gtk gbhed)
}

src_install() {
	emake -C src DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	doman doc/abtranslate.1

	if use gtk ; then
		insinto "${GAMES_DATADIR}"/${PN}/pixmaps
		doins pixmaps/*.{jpg,png,xpm}
		newicon pixmaps/gbhed48.png ${PN}.png
		make_desktop_entry gbhed ${PN}
		doman doc/gbhed.1
	fi

	prepgamesdirs
}
