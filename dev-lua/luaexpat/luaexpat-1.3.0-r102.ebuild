# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="https://matthewwild.co.uk/projects/luaexpat/"
SRC_URI="https://matthewwild.co.uk/projects/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ~ppc ~ppc64 sparc x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/expat
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/us/." )

src_prepare() {
	default

	# Respect users CFLAGS
	# Add '-DLUA_32BITS' for fixing compilation with lua5.3
	sed -e 's/-O2/-DLUA_32BITS/g' -i Makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INC=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CDIR=$(lua_get_cmod_dir)"
		"LUA_INC=$(lua_get_include_dir)"
		"LUA_LDIR=$(lua_get_lmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
