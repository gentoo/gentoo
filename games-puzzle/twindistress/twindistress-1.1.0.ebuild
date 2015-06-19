# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/twindistress/twindistress-1.1.0.ebuild,v 1.7 2015/02/25 22:15:46 tupone Exp $

EAPI=5
inherit eutils games

MY_P="twind-${PV}"
DESCRIPTION="Match and remove all of the blocks before time runs out"
HOMEPAGE="http://twind.sourceforge.net/"
SRC_URI="mirror://sourceforge/twind/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer
	media-libs/sdl-image[png]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e '/^CC/d' \
		-e "/^CFLAGS/s:-g:${CFLAGS}:" \
		-e "/^DATA_PREFIX/s:/.*$:${GAMES_DATADIR}/${PN}/:" \
		-e "/^HIGH_SCORE_PREFIX/s:/.*$:${GAMES_STATEDIR}/${PN}/:" \
		Makefile || die "sed failed"
	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-warnings.patch
}

src_install() {
	dogamesbin twind

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r graphics music sound

	doicon graphics/twind.png
	make_desktop_entry twind "Twin Distress"

	dodoc AUTHORS ChangeLog CREDITS NEWS README TODO

	dodir "${GAMES_STATEDIR}/${PN}"
	touch "${D}/${GAMES_STATEDIR}/${PN}/twind.hscr"
	fperms 660 "${GAMES_STATEDIR}/${PN}/twind.hscr"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! has_version "media-libs/sdl-mixer[vorbis]" ; then
		ewarn "Music support will be disabled since sdl-mixer"
		ewarn "wasn't built with USE=vorbis"
	fi
}
