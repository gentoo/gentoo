# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils

DESCRIPTION="Brain teasers, puzzle and memory games for kid's in one pack"
HOMEPAGE="http://www.viewizard.com/memonix/"
SRC_URI="http://www.viewizard.com/download/${PN}_${PV}_src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl:0[sound,opengl,video,X]
	media-libs/sdl-image[jpeg]
	media-libs/sdl-mixer[vorbis]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/MemonixSourceCode"

src_install() {
	exeinto /usr/"$(get_libdir)"
	doexe ../${P}_build/Memonix

	insinto "/usr/share/${PN}"
	doins ../gamedata.vfs

	make_wrapper ${PN} /usr/"$(get_libdir)"/Memonix /usr/share/${PN}

	newicon ../icon48.png ${PN}.png
	make_desktop_entry ${PN}

	dodoc ReadMe.txt
}
