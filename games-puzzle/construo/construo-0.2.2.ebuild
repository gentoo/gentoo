# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/construo/construo-0.2.2.ebuild,v 1.17 2015/02/11 06:34:32 mr_bones_ Exp $

EAPI=5
inherit eutils autotools games

DESCRIPTION="2d construction toy with objects that react on physical forces"
HOMEPAGE="http://www.nongnu.org/construo/"
SRC_URI="http://freesoftware.fsf.org/download/construo/construo.pkg/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freeglut
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-lGLU.patch
	eautoreconf
}

src_configure() {
	egamesconf --datadir="${GAMES_DATADIR_BASE}"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		bindir="${GAMES_BINDIR}" install
	dodoc AUTHORS NEWS README TODO
	prepgamesdirs
}
