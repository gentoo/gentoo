# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="David Kolf's JSON module for Lua"
HOMEPAGE="http://dkolf.de/src/dkjson-lua.fsl/"
SRC_URI="http://dkolf.de/dkjson-lua/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

DOCS=( "readme.txt" )

lua_src_test() {
	${ELUA} jsontest.lua || die
	${ELUA} speedtest.lua ${PN} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins dkjson.lua
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
