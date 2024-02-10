# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )
LUA_REQ_USE="deprecated"

inherit flag-o-matic lua-single

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="https://love2d.org/"
SRC_URI="https://github.com/love2d/${PN}/releases/download/${PV}/${P}-linux-src.tar.gz"

LICENSE="ZLIB"
SLOT="0.7"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-games/physfs
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.2-opengl_glext_prototypes.patch
	"${FILESDIR}"/${PN}-0.8.0-freetype2.patch
)

src_prepare() {
	default
	append-cppflags -DLUA_COMPAT_OPENLIB
}

src_install() {
	DOCS="readme.txt changes.txt" \
		default

	mv "${ED}/usr/bin/${PN}" "${ED}/usr/bin/${PN}-${SLOT}" || die
}
