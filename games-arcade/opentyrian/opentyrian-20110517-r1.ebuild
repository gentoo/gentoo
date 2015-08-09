# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit base games

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="http://code.google.com/p/opentyrian/"
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
	dogamesbin opentyrian || die "Failed to install game binary"
	dosym "${GAMES_BINDIR}/opentyrian" "${GAMES_BINDIR}/tyrian" || die "Failed to symlink"
	dodoc CREDITS NEWS README || die "Failed to install documentation"
	domenu linux/opentyrian.desktop || die "Failed to install desktop file"
	for i in linux/icons/*.png ; do
		local size=`echo ${i} | sed -e 's:.*-\([0-9]\+\).png:\1:'`
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins ${i} opentyrian.png || die "Failed to install program icon"
	done
	insinto "${GAMES_DATADIR}/${PN}"
	cd "${WORKDIR}/tyrian21"
	doins * || die "Failed to install game data"
	prepgamesdirs
}
