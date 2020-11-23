# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="File System Library for the Lua programming language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
SRC_URI="https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/lua-5.1:0
	luajit? ( dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "doc/us/." )

src_prepare() {
	default

	cat > "config" <<-EOF
		CC=$(tc-getCC)
		CFLAGS=${CFLAGS} -I$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua')) -fPIC
		DESTDIR=${ED}
		LIB_OPTION=${LDFLAGS} -shared
		LUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))
	EOF
}

src_test() {
	LUA_CPATH="src/lfs.so" lua tests/test.lua || die
}
