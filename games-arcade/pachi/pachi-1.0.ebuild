# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/pachi/pachi-1.0.ebuild,v 1.11 2015/01/08 22:57:49 mr_bones_ Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="platform game inspired by games like Manic Miner and Jet Set Willy"
HOMEPAGE="http://dragontech.sourceforge.net/index.php?main=pachi&lang=en"
# Upstream doesn't version their releases.
# (should be downloaded and re-compressed with tar -jcvf)
#SRC_URI="mirror://sourceforge/dragontech/pachi_source.tgz"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/Pachi

src_prepare() {
	epatch "${FILESDIR}"/${PV}-autotools.patch
	rm -f missing
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	newicon Tgfx/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Pachi /usr/share/pixmaps/${PN}.bmp
	prepgamesdirs
}
