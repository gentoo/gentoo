# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop eapi7-ver

DESCRIPTION="Trap and capture penguins on Antarctica"
HOMEPAGE="http://www.mattdm.org/icebreaker/"
SRC_URI="http://www.mattdm.org/${PN}/$(ver_cut 1-2).x/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[video]
	media-libs/sdl-mixer
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-parallell-install.patch
	"${FILESDIR}"/${P}-ovfl.patch
)

src_compile() {
	emake \
		OPTIMIZE="${CFLAGS}" \
		prefix=/usr \
		bindir=/usr/bin \
		datadir=/usr/share \
		highscoredir="/var"
}

src_install() {
	emake \
		prefix="${D}/usr" \
		bindir="${D}/usr/bin" \
		datadir="${D}/usr/share" \
		highscoredir="${D}/var" install

	newicon ${PN}_48.bmp ${PN}.bmp
	make_desktop_entry ${PN} IceBreaker /usr/share/pixmaps/${PN}.bmp
	einstalldocs
}
