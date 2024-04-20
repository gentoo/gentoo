# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Lightweight, native, lazy evaluating multithreading library"
HOMEPAGE="https://github.com/LuaLanes/lanes"
SRC_URI="https://github.com/LuaLanes/lanes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Tests are currently somehow problematic.
# https://github.com/LuaLanes/lanes/issues/197
# https://github.com/LuaLanes/lanes/issues/198
RESTRICT="test"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )
"

HTML_DOCS=( "docs/." )

PATCHES=(
	"${FILESDIR}/${PN}-3.13.0-makefile.patch"
)

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA=${ELUA}"
		"LUA_FLAGS=$(lua_get_CFLAGS)"
		"LUA_LIBS="
		"OPT_FLAGS=${CFLAGS}"
	)

	tc-export PKG_CONFIG

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die

	emake LUA="${ELUA}" test

	popd
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"LUA_LIBDIR=${ED}/$(lua_get_cmod_dir)"
		"LUA_SHAREDIR=${ED}/$(lua_get_lmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
