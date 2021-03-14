# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Feature-rich command line parser for Lua"
HOMEPAGE="https://github.com/luarocks/argparse"
SRC_URI="https://github.com/luarocks/${PN/lua-/}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//lua-/}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

lua_src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/argparse.lua
}

src_install() {
	default
	lua_foreach_impl lua_src_install
}
