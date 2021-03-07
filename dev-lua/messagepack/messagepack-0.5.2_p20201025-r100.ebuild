# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="18f316b3f62c02bf2b7a3096701780f78a4d2c67"
LUA_COMPAT=( lua5-{1..2} luajit )
MY_PN="lua-MessagePack"
MY_P="${MY_PN}-${EGIT_COMMIT}"

inherit lua toolchain-funcs

DESCRIPTION="A pure Lua implementation of the MessagePack serialization format"
HOMEPAGE="https://fperrad.frama.io/lua-MessagePack"
SRC_URI="https://framagit.org/fperrad/${MY_PN}/-/archive/${EGIT_COMMIT}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

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
