# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils games

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="https://code.google.com/p/opentyrian/"
SRC_URI="http://darklomax.org/tyrian/tyrian21.zip
	 mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

RDEPEND="media-libs/libsdl
	media-libs/sdl-net"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-vcs/subversion"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-datapath.diff"
	if  ! use debug; then
		sed -i -e "s@DEBUG := 1@DEBUG := 0@" "${S}/Makefile" || die "sed failed"
	fi
}

src_compile() {
	emake DATA_PATH="${GAMES_DATADIR}/${PN}" || die "Compilation failed"
}

src_install() {
	dogamesbin tyrian || die "Failed to install game binary"
	dodoc CREDITS NEWS README || die "Failed to install documentation"
	domenu opentyrian.desktop || die "Failed to install desktop file"
	doicon tyrian.xpm || die "Failed to install program icon"
	insinto "${GAMES_DATADIR}/${PN}"
	cd "${WORKDIR}/tyrian21"
	doins * || die "Failed to install game data"
	prepgamesdirs
}
