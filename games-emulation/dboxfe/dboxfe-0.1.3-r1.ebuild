# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Creates and manages configuration files for DOSBox"
HOMEPAGE="https://sourceforge.net/projects/dboxfe.berlios/"
SRC_URI="mirror://sourceforge/dboxfe.berlios/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}
	>=games-emulation/dosbox-0.65"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
)

src_install() {
	default
	dobin bin/dboxfe
	newicon res/default.png ${PN}.png
	make_desktop_entry dboxfe "DosBoxFE"
}
