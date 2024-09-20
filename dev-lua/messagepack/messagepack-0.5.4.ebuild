# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PN="lua-MessagePack"
MY_P="${MY_PN}-${PV}"

inherit lua

DESCRIPTION="pure Lua implementation of the MessagePack serialization format"
HOMEPAGE="https://fperrad.frama.io/lua-MessagePack"
SRC_URI="https://framagit.org/fperrad/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Needed 'lua-TestMore' Lua module not in tree
RESTRICT="test"

RDEPEND="${LUA_DEPS}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

src_compile() {
	:;
}

lua_src_install() {
	local myemakeargs=(
		"LIBDIR=${ED}/$(lua_get_lmod_dir)"
		"LUAVER=$(ver_cut 1-2 $(lua_get_version))"
	)

	emake "${myemakeargs[@]}" install
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
