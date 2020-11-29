# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A UTF-8 support module for Lua and LuaJIT"
HOMEPAGE="https://github.com/starwing/luautf8"
SRC_URI="https://github.com/starwing/luautf8/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//-/}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ppc64 ~x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"${LDFLAGS}"
		"-I/usr/include"
		"-c lutf8lib.c"
		"-o lutf8lib.o"
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die

	local linker=(
		"$(tc-getCC)"
		"-shared"
		"${LDFLAGS}"
		"-o lutf8lib.so"
		"lutf8lib.o"
	)
	einfo "${linker[@]}"
	${linker[@]} || die
}

src_test() {
	local mytests=(
		"test.lua"
		"test_compat.lua"
		"test_pm.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="${S}/lutf8lib.so" $(usex luajit 'luajit' 'lua') ${mytest} || die
	done
}

src_install() {
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
	newexe "lutf8lib.so" "lua-utf8.so"

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
	doins parseucd.lua

	einstalldocs
}
