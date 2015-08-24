# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit base games

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="https://code.google.com/p/opentyrian/"
SRC_URI="http://darklomax.org/tyrian/tyrian21.zip
	 mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
S="${WORKDIR}/${PN}"

RDEPEND="media-libs/libsdl
	media-libs/sdl-net"
# Yes, mercurial is needed to set the build version stamp.
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-vcs/mercurial"
PATCHES=(
	"${FILESDIR}/${PV}-datapath.diff"
	"${FILESDIR}/${PV}-cflag-idiocy.diff"
)

src_compile() {
	emake DATA_PATH="${GAMES_DATADIR}/${PN}" || die "Compilation failed"
}

src_install() {
	newgamesbin opentyrian tyrian || die "Failed to install game binary"
	dodoc CREDITS NEWS README || die "Failed to install documentation"
	domenu linux/opentyrian.desktop || die "Failed to install desktop file"
	doicon linux/icons/* || die "Failed to install program icons"
	insinto "${GAMES_DATADIR}/${PN}"
	cd "${WORKDIR}/tyrian21"
	doins * || die "Failed to install game data"
	prepgamesdirs
}
