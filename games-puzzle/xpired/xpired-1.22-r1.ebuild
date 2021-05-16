# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="A Sokoban-styled puzzle game with lots more action"
HOMEPAGE="http://xpired.sourceforge.net"
SRC_URI="mirror://sourceforge/xpired/${P}-linux_source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/sdl-gfx
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[mod]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/src"

PATCHES=( "${FILESDIR}"/${P}-ldflags.patch )

src_compile() {
	emake \
		PREFIX=/usr \
		SHARE_PREFIX=/usr/share/xpired
}

src_install() {
	emake \
		PREFIX="${D}/usr" \
		SHARE_PREFIX="${D}/usr/share/${PN}" \
		install

	newicon img/icon.bmp ${PN}.bmp
	make_desktop_entry xpired Xpired /usr/share/pixmaps/${PN}.bmp
	make_desktop_entry xpiredit "Xpired Level Editor"

	einstalldocs
}
