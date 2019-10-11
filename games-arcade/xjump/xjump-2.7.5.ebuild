# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DEBIAN_PATCH="6.1"
DESCRIPTION="An X game where one tries to jump up as many levels as possible"
HOMEPAGE="http://packages.debian.org/stable/games/xjump"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}-${DEBIAN_PATCH}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXt"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${P}.orig

src_prepare() {
	# Where we will keep the highscore file:
	HISCORE_FILENAME=xjump.hiscores
	HISCORE_FILE="${GAMES_STATEDIR}/${HISCORE_FILENAME}"

	epatch \
		"${WORKDIR}"/debian/patches/0*.patch \
		"${FILESDIR}"/${P}-ldflags.patch

	# set up where we will keep the highscores file:
	sed -i \
		-e "/^CC/d" \
		-e "/^CFLAGS/d" \
		-e "s,/var/games/xjump,${GAMES_STATEDIR}," \
		-e "s,/record,/${HISCORE_FILENAME}," \
		Makefile || die
}

src_install() {
	dogamesbin xjump
	dodoc README.euc

	# Set up the hiscores file:
	dodir "${GAMES_STATEDIR}"
	touch "${D}/${HISCORE_FILE}"
	fperms 660 "${HISCORE_FILE}"
	prepgamesdirs
}
