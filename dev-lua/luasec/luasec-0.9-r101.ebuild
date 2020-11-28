# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
LUA_REQ_USE="deprecated"

inherit lua toolchain-funcs

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication"
HOMEPAGE="https://github.com/brunoos/luasec"
SRC_URI="https://github.com/brunoos/luasec/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libressl"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	>=dev-lua/luasocket-3.0_rc1_p20200328-r100[${LUA_USEDEP}]
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O2//g' -i src/Makefile || die
}

lua_src_compile() {
	# Clean project, to compile it for every lua slot
	emake clean

	# Generate SSL options
	${ELUA} src/options.lua -g /usr/include/openssl/ssl.h > src/options.c || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"INC_PATH=-I$(lua_get_include_dir)"
		"LIB_PATH=$(lua_get_CFLAGS)"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
	)

	emake "${myemakeargs[@]}" linux

	# Copy module to match the choosen LUA implementation
	cp "src/ssl.so" "src/ssl-${ELUA}.so" || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "src/ssl-${ELUA}.so" "src/ssl.so" || die

	local emakeargs=(
		"DESTDIR=${ED}"
		"LUAPATH=$(lua_get_lmod_dir)"
		"LUACPATH=$(lua_get_cmod_dir)"
	)

	emake "${emakeargs[@]}" install
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
