# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )
inherit autotools lua-single

DESCRIPTION="A space adventure/combat game"
HOMEPAGE="https://epiar.net/"
SRC_URI="https://github.com/cthielen/Epiar/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-games/physfs
	dev-libs/libxml2
	media-libs/ftgl
	media-libs/libsdl[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
	x11-libs/libX11
	virtual/opengl
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.1-unbundle-lua5.1.patch
	"${FILESDIR}"/${PN}-0.5.1-fix-bashisms.patch
)

src_prepare() {
	default

	# Remove bundled Lua 5.1
	rm -rf source/lua || die

	eautoreconf
}
