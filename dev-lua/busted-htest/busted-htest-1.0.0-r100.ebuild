# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="Pretty output handler for Busted"
HOMEPAGE="https://github.com/hishamhm/busted-htest"
SRC_URI="https://github.com/hishamhm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 x86"

RDEPEND="
	dev-lua/busted[${LUA_USEDEP}]
	${LUA_DEPS}
"

BDEPEND="virtual/pkgconfig"

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins src/busted/outputHandlers/htest.lua

	einstalldocs
}

src_install() {
	lua_foreach_impl lua_src_install
}
