# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/tarruda/libmpack/"
SRC_URI="https://github.com/tarruda/libmpack/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libmpack-${PV}/binding/lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="luajit test"

RDEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:2= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted )"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} $($(tc-getPKG_CONFIG) --cflags $(usex luajit 'luajit' 'lua')) -fPIC -DPIC -shared lmpack.c -o mpack.so || die
}

src_test() {
	busted -o gtest test.lua || die
}

src_install() {
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
	doexe mpack.so
}
