# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"
SRC_URI="https://github.com/LuaLanes/lanes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "docs/." )

PATCHES=( "${FILESDIR}/${PN}-3.13.0-makefile.patch" )

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA=$(usex luajit 'luajit' 'lua')"
		"LUA_FLAGS=-I$($(tc-getPKG_CONFIG) --variable $(usex luajit 'includedir' 'INSTALL_INC') $(usex luajit 'luajit' 'lua'))"
		"LUA_LIBS="
		"OPT_FLAGS=${CFLAGS}"
	)

	emake "${myemakeargs[@]}"
}

src_test() {
	emake LUA=$(usex luajit 'luajit' 'lua') test
}

src_install() {
	local myemakeargs=(
		"LUA_LIBDIR=${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"LUA_SHAREDIR=${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
	)

	emake "${myemakeargs[@]}" install

	einstalldocs
}
