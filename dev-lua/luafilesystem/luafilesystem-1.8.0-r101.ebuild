# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="File System Library for the Lua programming language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
SRC_URI="https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 sparc x86"
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
	pushd "${BUILD_DIR}" || die
	cat > "config-${ELUA}" <<-EOF
		CC=$(tc-getCC)
		DESTDIR=${ED}
		CFLAGS=${CFLAGS} $(lua_get_CFLAGS) -fPIC
		LIB_OPTION=${LDFLAGS} -shared
		LUA_LIBDIR=$(lua_get_cmod_dir)
	EOF
	popd
}

src_prepare() {
	default

	lua_copy_sources
	lua_foreach_impl lua_src_prepare
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die
	emake CONFIG="config-${ELUA}"
	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die
	LUA_CPATH="${BUILD_DIR}/src/?.so" ${ELUA} tests/test.lua || die
	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die
	emake CONFIG="config-${ELUA}" install
	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
