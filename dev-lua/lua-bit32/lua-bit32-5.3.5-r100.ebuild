# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 luajit )

MY_PN="lua-compat-5.3"
MY_PV="0.10"

inherit lua toolchain-funcs

DESCRIPTION="Backported Lua bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.3"
SRC_URI="https://github.com/keplerproject/${MY_PN}/archive/v${MY_PV}.tar.gz -> lua-compat53-${MY_PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

src_compile() {
	compiler="$(tc-getCC) ${CFLAGS} -fPIC ${LDFLAGS} -DLUA_COMPAT_BITLIB -Ic-api -c lbitlib.c -o lbitlib.o"
	einfo "${compiler}"
	eval "${compiler}" || die

	linker="$(tc-getCC) -shared ${LDFLAGS} -o bit32.so lbitlib.o"
	einfo "${linker}"
	eval "${linker}" || die
}

lua_src_test() {
	LUA_CPATH="./?.so" "${ELUA}" "tests/test-bit32.lua" || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	exeinto "$(lua_get_cmod_dir)"
	doexe bit32.so
}

src_install() {
	default

	lua_foreach_impl lua_src_install
}
