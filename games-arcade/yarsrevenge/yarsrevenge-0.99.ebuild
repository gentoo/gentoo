# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/yarsrevenge/yarsrevenge-0.99.ebuild,v 1.14 2015/01/06 09:58:33 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="remake of the Atari 2600 classic Yar's Revenge"
HOMEPAGE="http://freshmeat.net/projects/yarsrevenge/"
SRC_URI="http://www.autismuk.freeserve.co.uk/yar-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]"
RDEPEND="${DEPEND}"
S=${WORKDIR}/yar-${PV}

PATCHES=(
	"${FILESDIR}"/${PV}-math.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc44.patch
)

src_install() {
	default
	prepgamesdirs
}
