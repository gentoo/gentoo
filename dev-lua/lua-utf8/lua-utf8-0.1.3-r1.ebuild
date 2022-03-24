# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A UTF-8 support module for Lua and LuaJIT"
HOMEPAGE="https://github.com/starwing/luautf8"
SRC_URI="https://github.com/starwing/luautf8/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN//-/}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

lua_src_compile() {
	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"${LDFLAGS}"
		"$(lua_get_CFLAGS)"
		"-c lutf8lib.c"
		"-o lutf8lib-${ELUA}.o"
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die

	local linker=(
		"$(tc-getCC)"
		"-shared"
		"${LDFLAGS}"
		"-o lutf8lib-${ELUA}.so"
		"lutf8lib-${ELUA}.o"
	)
	einfo "${linker[@]}"
	${linker[@]} || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	local mytests=(
		"test.lua"
		"test_compat.lua"
		"test_pm.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="${S}/lutf8lib-${ELUA}.so" ${ELUA} ${mytest} || die
	done
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	exeinto "$(lua_get_cmod_dir)"
	newexe "lutf8lib-${ELUA}.so" "lua-utf8.so"

	insinto "$(lua_get_lmod_dir)"
	doins parseucd.lua
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
