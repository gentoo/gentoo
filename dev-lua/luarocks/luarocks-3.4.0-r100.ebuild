# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua-single

DESCRIPTION="A package manager for the Lua programming language"
HOMEPAGE="http://www.luarocks.org"
SRC_URI="http://luarocks.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="libressl test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${LUA_DEPS}"

DEPEND="
	net-misc/curl
	libressl? ( dev-libs/libressl:0 )
	!libressl? ( dev-libs/openssl:0 )
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? (
		$(lua_gen_cond_dep '>=dev-lua/busted-2.0.0-r100[${LUA_USEDEP}]')
		$(lua_gen_cond_dep '>=dev-lua/busted-htest-1.0.0-r100[${LUA_USEDEP}]')
		${RDEPEND}
	)
"

src_configure() {
	local myeconfargs=(
		"--prefix=${EPRIFIX}/usr"
		"--rocks-tree=$(lua_get_lmod_dir)"
		"--with-lua-include=$(lua_get_include_dir)"
		"--with-lua-interpreter=${ELUA}"
		"--with-lua-lib=$(lua_get_cmod_dir)"
	)

	# Since the configure script is handcrafted,
	# and yells at unknown options, do not use 'econf'.
	./configure "${myeconfargs[@]}" || die
}

src_test() {
	busted --lua=${ELUA} || die
}

src_install() {
	default

	{ find "${D}" -type f -exec sed -i -e "s:${D}::g" {} \;; } || die
}
