# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A package manager for the Lua programming language"
HOMEPAGE="https://luarocks.org"
SRC_URI="https://luarocks.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="luajit libressl test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
"

DEPEND="
	net-misc/curl
	libressl? ( dev-libs/libressl:0 )
	!libressl? ( dev-libs/openssl:0 )
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted
		dev-lua/busted-htest
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
		"--rocks-tree=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"--with-lua-include=$($(tc-getPKG_CONFIG) --variable $(usex luajit 'includedir' 'INSTALL_INC') $(usex luajit 'luajit' 'lua'))"
		"--with-lua-interpreter=$(usex luajit 'luajit' 'lua')"
		"--with-lua-lib=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
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
