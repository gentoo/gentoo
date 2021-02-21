# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PN="Penlight"

inherit lua toolchain-funcs

DESCRIPTION="Lua utility libraries loosely based on the Python standard libraries"
HOMEPAGE="https://github.com/Tieske/Penlight"
SRC_URI="https://github.com/Tieske/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}"

RDEPEND="
	dev-lua/luafilesystem[${LUA_USEDEP}]
	${DEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? ( ${DEPEND} )
"

HTML_DOCS=( "docs/." )

src_prepare() {
	default

	# This is a demo app, not a real test
	rm tests/test-app.lua || die

	# Remove test for executing a non-existent command
	sed -e '/most-likely-nonexistent-command/d' -i tests/test-utils3.lua || die
}

lua_src_test() {
	"${ELUA}" run.lua || die
}

src_test() {
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
