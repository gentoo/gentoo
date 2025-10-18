# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

DESCRIPTION="Syobon Action (also known as Cat Mario or Neko Mario)"
HOMEPAGE="http://zapek.com/?p=189"
SRC_URI="http://zapek.com/wp-content/uploads/2010/09/${PN}_${PV}_src.tar.gz"

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
