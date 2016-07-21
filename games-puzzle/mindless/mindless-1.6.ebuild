# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

ORANAME="OracleAll_050523.txt"
DESCRIPTION="play collectable/trading card games (Magic: the Gathering and possibly others) against other people"
HOMEPAGE="http://mindless.sourceforge.net/"
SRC_URI="mirror://sourceforge/mindless/${P}.tar.gz
	http://www.wizards.com/dci/oracle/${ORANAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="mirror" # for the card database

RDEPEND="x11-libs/gtk+:2
	media-fonts/font-schumacher-misc"
DEPEND="${RDEPEND}
	gnome-base/librsvg
	virtual/pkgconfig"

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/${ORANAME}" "${WORKDIR}" || die "cp failed"
	DATAFILE="${GAMES_DATADIR}/${PN}/${ORANAME}"
}

src_prepare() {
	sed -i \
		-e '/^CC=/d' \
		-e '/^CFLAGS=/d' \
		Makefile \
		|| die 'sed failed'
}

src_install() {
	dogamesbin mindless
	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}/${ORANAME}"
	dodoc CHANGES README TODO
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "The first time you start ${PN} you need to tell it where to find"
	elog "the text database of cards.  This file has been installed at:"
	elog "${DATAFILE}"
	echo
}
