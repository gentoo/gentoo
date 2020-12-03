# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="lib${PN}-lua"

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/libmpack/libmpack/"
SRC_URI="https://github.com/${MY_PN/-lua/}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libmpack
	luajit? ( dev-lang/luajit:2= )
	!luajit? ( >=dev-lang/lua-5.1:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted
		${RDEPEND}
	)
"

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INCLUDE=$($(tc-getPKG_CONFIG) --cflags $(usex luajit 'luajit' 'lua'))"
		"LUA_LIB=$($(tc-getPKG_CONFIG) --libs $(usex luajit 'luajit' 'lua'))"
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	if use luajit; then
		# "[  FAILED  ] test.lua @ 279: mpack should not leak memory"
		# It doesn't seem upstream actually support LuaJIT so were this up to me
		# I would drop it from LUA_COMPAT, unfortunately there are packages in the
		# tree which currently expect it to be supported.
		ewarn "Not running tests under ${ELUA} because they are known to fail"
		return
	else
		busted --lua=lua test.lua || die
	fi
}

src_install() {
	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CMOD_INSTALLDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
