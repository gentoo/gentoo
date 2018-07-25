# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

MY_P="${PN}_${PV}_src"

DESCRIPTION="Syobon Action (also known as Cat Mario or Neko Mario)"
HOMEPAGE="http://zapek.com/?p=189"
SRC_URI="http://download.zapek.com/software/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[sound,video,joystick]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}"

src_compile() {
	emake GAMEDATA="/usr/share/${PN}"
}

src_install() {
	dobin ${PN}

	insinto "/usr/share/${PN}"
	doins -r BGM SE res
	einstalldocs

	make_desktop_entry ${PN}
}
