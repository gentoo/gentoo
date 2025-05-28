# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit edo lua toolchain-funcs

MY_PN="lua-${PN/53/-5.3}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Compatibility module providing Lua-5.3-style APIs for Lua 5.2 and 5.1"
HOMEPAGE="https://github.com/lunarmodules/lua-compat-5.3/"
SRC_URI="https://github.com/lunarmodules/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# change to name of compat53.'module' calls
	# this is required, see rockspecs
	mv lbitlib.c bitlib.c || die
	mv liolib.c io.c || die
	mv lstrlib.c string.c || die
	mv ltablib.c table.c || die
	mv lutf8lib.c utf8.c || die
	lua_copy_sources
}

lua_src_compile() {
	cd "${BUILD_DIR}" || die
	local u=""
	for u in *.c; do
		edo $(tc-getCC) -shared -fPIC \
			${CPPFLAGS} \
			${CFLAGS} $(lua_get_CFLAGS) \
			${SOFLAGS} \
			${LDFLAGS} $(lua_get_LIBS) \
			-o "${u/.c/.so}" ${u} c-api/compat-5.3.c
	done
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	cd "${BUILD_DIR}" || die
	insinto $(lua_get_lmod_dir)/${PN}
	doins compat53/*.lua
	exeinto $(lua_get_cmod_dir)/${PN}
	doexe *.so
}

src_install() {
	lua_foreach_impl lua_src_install
	doheader c-api/*
	einstalldocs
}
