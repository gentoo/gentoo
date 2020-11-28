# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )
MY_PN="Penlight"

inherit lua toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="https://github.com/Tieske/Penlight",
SRC_URI="https://github.com/Tieske/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}"

RDEPEND="
	>=dev-lua/luafilesystem-1.8.0-r100
	${DEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? ( ${DEPEND} )
"

HTML_DOCS=( "docs/." )

lua_src_test() {
	${ELUA} run.lua || die
}

src_test() {
	# This is a demo app, not a real test
	rm tests/test-app.lua

	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins -r lua/pl

	einstalldocs
}

src_install() {
	lua_foreach_impl lua_src_install
}
