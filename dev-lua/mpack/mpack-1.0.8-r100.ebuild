# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

MY_PN="lib${PN}-lua"

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/libmpack/libmpack/"
SRC_URI="https://github.com/${MY_PN/-lua/}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libmpack
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		${RDEPEND}
	)
"

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INCLUDE=$(lua_get_CFLAGS)"
		"LUA_LIB="
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	# "[  FAILED  ] test.lua @ 279: mpack should not leak memory"
	# It doesn't seem upstream actually support LuaJIT so were this up to me
	# I would drop it from LUA_COMPAT, unfortunately there are packages in the
	# tree which currently expect it to be supported.
	if [[ ${ELUA} == "luajit" ]]; then
		ewarn "Not running tests under ${ELUA} because they are known to fail"
		return
	fi

	busted --lua="${ELUA}" test.lua || die

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CMOD_INSTALLDIR=$(lua_get_cmod_dir)"
		"USE_SYSTEM_MPACK=yes"
		"USE_SYSTEM_LUA=yes"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
