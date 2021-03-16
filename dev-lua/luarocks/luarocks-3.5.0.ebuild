# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single

DESCRIPTION="A package manager for the Lua programming language"
HOMEPAGE="https://luarocks.org"
SRC_URI="https://luarocks.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 x86"
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
		$(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]')
		$(lua_gen_cond_dep 'dev-lua/busted-htest[${LUA_USEDEP}]')
		${RDEPEND}
	)
"

src_prepare() {
	default

	# If 'dev-lang/lua' is a new, fresh installation, no 'LUA_LIBDIR' exists,
	# as no compiled modules are installed on a new, fresh installation,
	# so this check must be disabled, otherwise 'configure' will fail.
	sed -e '/LUA_LIBDIR is not a valid directory/d' -i configure || die
}

src_configure() {
	local myeconfargs=(
		"--prefix=${EPREFIX}/usr"
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

pkg_postinst() {
	local lua_abi_ver
	if use lua_single_target_luajit; then
		lua_abi_ver="5.1"
	else
		lua_abi_ver=${ELUA#lua}
	fi
	elog
	elog "To manage rocks for a Lua version other than the current ${CATEGORY}/${PN} default (${lua_abi_ver})"
	elog "you can use the command-line option --lua-version, e.g."
	elog
	elog "    luarocks --lua-version 5.3 install luasocket"
	elog
	elog "(use 5.1 for luajit). Note that the relevant Lua version must already be present in the system."
	elog
}
