# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop

DESCRIPTION="An open-source platform game with a sketched and minimalistic look"
HOMEPAGE="http://jvgs.sourceforge.net/"
SRC_URI="mirror://sourceforge/jvgs/${P}-src.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/lua:0
	media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	media-libs/freetype:2
	sys-libs/zlib:=
	virtual/opengl"
DEPEND="${RDEPEND}
	dev-lang/swig"

S=${WORKDIR}/${P}-src
PATCHES=( "${FILESDIR}"/${PN}-0.5-fix-build-system.patch )

src_install() {
	dobin src/${PN}

	insinto /usr/share/${PN}
	doins -r main.lua resources

	newicon resources/drawing.svg ${PN}.svg
	make_desktop_entry ${PN} ${PN}

	einstalldocs
}
