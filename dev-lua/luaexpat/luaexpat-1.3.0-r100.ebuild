# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
LUA_REQ_USE="${MULTILIB_USEDEP}"

inherit lua multilib-minimal toolchain-funcs

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="https://matthewwild.co.uk/projects/luaexpat/"
SRC_URI="https://matthewwild.co.uk/projects/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
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

	multilib_copy_sources
}

lua_multilib_src_compile() {
	# Clean project, to compile it for every lua slot
	emake clean

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LUA_INC=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}"

	# Copy module to match the choosen LUA implementation
	cp "src/lxp.so" "src/lxp-${ELUA}.so" || die
}

multilib_src_compile() {
	lua_foreach_impl lua_multilib_src_compile
}

lua_multilib_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "src/lxp-${ELUA}.so" "src/lxp.so" || die

	local myemakeargs=(
		"DESTDIR=${ED}"
		"LUA_CDIR=$(lua_get_cmod_dir)"
		"LUA_INC=$(lua_get_include_dir)"
		"LUA_LDIR=$(lua_get_lmod_dir)"
	)

	emake "${myemakeargs[@]}" install
}

multilib_src_install() {
	lua_foreach_impl lua_multilib_src_install
}

multilib_src_install_all() {
	einstalldocs
}
