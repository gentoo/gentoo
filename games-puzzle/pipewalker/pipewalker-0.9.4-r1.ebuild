# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop flag-o-matic

DESCRIPTION="Rotating pieces puzzle game"
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/pipewalker/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[opengl,video]
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

src_configure() {
	append-flags $(sdl-config --cflags)
	econf --datadir="/usr/share"
}

src_install() {
	emake -C data DESTDIR="${D}" install
	dobin src/${PN}
	doicon extra/${PN}.xpm
	make_desktop_entry ${PN} PipeWalker
	einstalldocs
}
