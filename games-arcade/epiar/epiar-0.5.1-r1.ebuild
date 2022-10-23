# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )
inherit autotools flag-o-matic lua-single

DESCRIPTION="Space adventure/combat game"
HOMEPAGE="https://epiar.net/"
SRC_URI="https://github.com/cthielen/Epiar/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	dev-libs/libxml2
	media-libs/ftgl
	media-libs/libsdl[opengl,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.1-unbundle-lua5.1.patch
	"${FILESDIR}"/${PN}-0.5.1-fix-bashisms.patch
)

src_prepare() {
	default

	# Remove bundled Lua 5.1
	rm -r source/lua || die

	eautoreconf
}

src_configure() {
	# -DLUA_COMPAT_OPENLIB=1 is required to enable the
	# deprecated (in 5.1) luaL_openlib API (#872803)
	append-cppflags -DLUA_COMPAT_OPENLIB=1

	default
}

src_install() {
	default

	# Game fails to start without this otherwise missing font.
	insinto /usr/share/epiar/resources/Fonts
	doins resources/Fonts/FreeSansBold.ttf
}
