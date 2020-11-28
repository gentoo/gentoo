# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/libmpack/libmpack/"
SRC_URI="https://github.com/libmpack/libmpack/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libmpack-${PV}/binding/lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	test? (
		${RDEPEND}
		dev-lua/busted[${LUA_USEDEP}]
	)"

lua_src_compile() {
	# Make sure we have got no leftovers from other implementations.
	# There is no 'clean' target in the makefile, though.
	rm -f ${PN}.so

	# We set LUA_LIB to an empty string while building version 1.0.4 because
	# compiled Lua modules must not link against liblua. This has already been
	# fixed upstream.
	emake \
		CC="$(tc-getCC)" \
		USE_SYSTEM_LUA=yes \
		LUA_INCLUDE="$(lua_get_CFLAGS)" \
		LUA_LIB=""

	# Tag the result with current implementation and move it out of the way.
	mv ${PN}.so ${PN}-${ELUA}.so || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	# "[  FAILED  ] test.lua @ 279: mpack should not leak memory"
	# It doesn't seem upstream actually support LuaJIT so were this up to me
	# I would drop it from LUA_COMPAT, unfortunately there are packages in the
	# tree which currently expect it to be supported.
	if [[ ${ELUA} == "luajit" ]]; then
		ewarn "Not running tests under ${ELUA} because they are known to fail"
		return
	fi

	# The test suite must be able to find the module under its original name.
	rm -f ${PN}.so
	ln -s ${PN}-${ELUA}.so ${PN}.so || die
	busted --lua="${ELUA}" -o gtest test.lua || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	# This time we move the correct library file back in order not to risk
	# confusing make with symlinks.
	mv ${PN}-${ELUA}.so ${PN}.so || die

	emake \
		DESTDIR="${ED}" \
		USE_SYSTEM_LUA=yes \
		LUA_CMOD_INSTALLDIR="$(lua_get_cmod_dir)" \
		install
}

src_install() {
	lua_foreach_impl lua_src_install
	einstalldocs
}
