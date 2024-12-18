# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="A base2, base16, base32, base64 and base85 library for Lua"
HOMEPAGE="https://github.com/aiq/basexx/"
SRC_URI="https://github.com/aiq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

lua_enable_tests busted test

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins lib/${PN}.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	einstalldocs
}
