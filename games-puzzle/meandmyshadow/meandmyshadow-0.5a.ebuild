# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{2..4} )
inherit xdg cmake lua-single

DESCRIPTION="Puzzle/platform game with a player and its shadow"
HOMEPAGE="https://acmepjz.github.io/meandmyshadow/"
SRC_URI="mirror://sourceforge/meandmyshadow/${PV}/${P}-src.tar.gz"

LICENSE="
	Apache-2.0 BitstreamVera CC-BY-SA-3.0 CC-BY-SA-4.0 CC0-1.0
	GPL-2+ GPL-3 GPL-3+ LGPL-2.1 OFL-1.1 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	app-arch/libarchive:=
	media-libs/libsdl2[sound,video]
	media-libs/sdl2-image[jpeg,png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-ttf
	net-misc/curl[ssl]"
DEPEND="${RDEPEND}"

DOCS=(
	AUTHORS ChangeLog README.md
	docs/{Controls,ScriptAPI,ThemeDescription}.md
)

src_configure() {
	local mycmakeargs=(
		-DLua_FIND_VERSION_MAJOR=$(ver_cut 1 $(lua_get_version))
		-DLua_FIND_VERSION_MINOR=$(ver_cut 2 $(lua_get_version))
		-DLua_FIND_VERSION_COUNT=2
		-DLua_FIND_VERSION_EXACT=ON
	)
	cmake_src_configure
}
