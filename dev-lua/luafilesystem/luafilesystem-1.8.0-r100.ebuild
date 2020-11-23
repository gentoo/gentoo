# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="File System Library for the Lua programming language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
SRC_URI="https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "doc/us/." )

lua_src_prepare() {
	cat > "config-${ELUA}" <<-EOF
		CC=$(tc-getCC)
		DESTDIR=${ED}
		CFLAGS=${CFLAGS} $(lua_get_CFLAGS) -fPIC
		LIB_OPTION=${LDFLAGS} -shared
		LUA_LIBDIR=$(lua_get_cmod_dir)
	EOF
}

src_prepare() {
	default

	lua_foreach_impl lua_src_prepare
}

lua_src_compile() {
	# Clean project to compile it for every lua slot
	emake clean

	emake CONFIG="config-${ELUA}"

	# Copy module to match the choosen LUA implementation
	cp "src/lfs.so" "src/lfs-${ELUA}.so" || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	LUA_CPATH="src/lfs-${ELUA}.so" ${ELUA} tests/test.lua || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "src/lfs-${ELUA}.so" "src/lfs.so" || die

	emake CONFIG="config-${ELUA}" install
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
