# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/dboxfe/dboxfe-0.1.3.ebuild,v 1.15 2015/02/21 12:31:16 ago Exp $

EAPI=5
inherit eutils qt4-r2 games

DESCRIPTION="Creates and manages configuration files for DOSBox"
HOMEPAGE="http://sourceforge.net/projects/dboxfe.berlios/"
SRC_URI="mirror://sourceforge/dboxfe.berlios/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}
	>=games-emulation/dosbox-0.65"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_configure() {
	qt4-r2_src_configure
}

src_install() {
	dogamesbin bin/dboxfe
	dodoc TODO ChangeLog
	newicon res/default.png ${PN}.png
	make_desktop_entry dboxfe "DosBoxFE"
	prepgamesdirs
}
