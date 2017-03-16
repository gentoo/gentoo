# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/tarruda/libmpack/"
SRC_URI="https://github.com/tarruda/libmpack/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libmpack-${PV}/binding/lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit test"

RDEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted )"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		USE_SYSTEM_LUA=yes \
		LUA_INCLUDE="$($(tc-getPKG_CONFIG) --cflags $(usex luajit 'luajit' 'lua'))" \
		LUA_LIB="$($(tc-getPKG_CONFIG) --libs $(usex luajit 'luajit' 'lua'))"
}

src_test() {
	busted -o gtest test.lua || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		USE_SYSTEM_LUA=yes \
		LUA_CMOD_INSTALLDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))" \
		install
}
