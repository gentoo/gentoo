# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="A simple and complete ini parser for Lua"
HOMEPAGE="https://github.com/bartbes/inifile/"
SRC_URI="https://github.com/bartbes/inifile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
BDEPEND="virtual/pkgconfig"

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins inifile.lua
}

src_install() {
	lua_foreach_impl lua_src_install
}
