# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Robbo, a popular Atari XE/XL game ported to Linux"
HOMEPAGE="http://gnurobbo.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnurobbo/${P}-source.tar.gz"

LICENSE="GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[sound,video,joystick]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-underlink.patch )

src_compile() {
	emake \
		PACKAGE_DATA_DIR="/usr/share/${PN}" \
		BINDIR="/usr/bin" \
		DOCDIR="/usr/share/doc/${PF}"
}

src_install() {
	dobin gnurobbo
	insinto "/usr/share/${PN}"
	doins -r data/{levels,skins,locales,rob,sounds}
	dodoc AUTHORS Bugs ChangeLog README TODO
	newicon icon32.png ${PN}.png
	make_desktop_entry ${PN} Gnurobbo
}
