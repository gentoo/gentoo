# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="Feature-rich command line parser for Lua"
HOMEPAGE="https://github.com/luarocks/argparse"
SRC_URI="https://github.com/luarocks/${PN/lua-/}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//lua-/}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

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
