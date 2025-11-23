# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

MY_PN="${PN}.lua"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Fifo library for Lua"
HOMEPAGE="https://github.com/daurnimator/fifo.lua"
SRC_URI="https://github.com/daurnimator/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

lua_enable_tests busted

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins ${PN}.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	local DOCS=( README.md LICENSE doc/index.md )
	einstalldocs
}
