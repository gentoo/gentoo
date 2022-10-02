# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A SAX XML parser based on the Expat library"
HOMEPAGE="https://github.com/lunarmodules/luaexpat"
SRC_URI="https://github.com/lunarmodules/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~sparc x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/expat
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "docs/." )

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O2//g' -i Makefile || die

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
