# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"
SRC_URI="https://www.bitbucket.org/rude/${PN}/downloads/${P}-linux-src.tar.gz"

LICENSE="ZLIB"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-games/physfs
	dev-lang/lua:0[deprecated]
	media-libs/devil[mng,png,tiff]
	media-libs/freetype:2
	media-libs/libmodplug
	media-libs/libsdl[joystick,opengl]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl
"
DEPEND="${RDEPEND}
	media-libs/libmng:0
	media-libs/tiff:0
"

S="${WORKDIR}/${PN}-HEAD"

PATCHES=( "${FILESDIR}"/${PN}-0.8.0-freetype2.patch )

src_install() {
	DOCS="readme.txt changes.txt" \
		default

	mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}-${SLOT}" || die
}
