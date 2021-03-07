# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PV="${PV/_p/-}"

inherit lua toolchain-funcs

DESCRIPTION="A command-line argument parsing module for Lua"
HOMEPAGE="https://github.com/amireh/lua_cliargs"
SRC_URI="https://github.com/amireh/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/." )

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins -r src/.
}

src_install() {
	lua_foreach_impl lua_src_install

	use examples && dodoc -r examples
	einstalldocs
}
