# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua

DESCRIPTION="A pure Lua implementation of the MessagePack serialization format"
HOMEPAGE="http://fperrad.github.io/lua-MessagePack/"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/lua-${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires lua-TestMore, which we currently haven't got in the tree
RESTRICT=test

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="${LUA_REQUIRED_USE}"

lua_src_install() {
	local src_postfix=""
	if [[ ${ELUA} != luajit ]] && $(ver_test $(lua_get_version) -ge 5.3); then
		src_postfix="5.3"
	fi

	insinto "$(lua_get_lmod_dir)"
	doins src${src_postfix}/MessagePack.lua
}

# nothing to compile
src_compile() { :; }

src_test() {
	lua_foreach_impl default
}

src_install() {
	lua_foreach_impl lua_src_install
	dodoc CHANGES README.md
}
