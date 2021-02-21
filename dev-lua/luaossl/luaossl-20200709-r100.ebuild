# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
MY_P="${PN}-rel-${PV}"

inherit lua toolchain-funcs

DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe"
HOMEPAGE="https://github.com/wahern/luaossl"
SRC_URI="https://github.com/wahern/${PN}/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/openssl:0[-bindist]
	!dev-lua/lua-openssl
	!dev-lua/luasec
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "doc/." )

src_prepare() {
	default

	# Remove Lua autodetection
	# Respect users CFLAGS
	sed -e '/LUAPATH :=/d' -e '/LUAPATH_FN =/d' -e '/HAVE_API_FN =/d' -e '/WITH_API_FN/d' -e 's/-O2//g' -i GNUmakefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"ALL_CPPFLAGS=${CPPFLAGS} $(lua_get_CFLAGS)"
		"libdir="
	)

	emake "${myemakeargs[@]}" openssl${LUA_VERSION}

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	if [[ ${ELUA} != luajit ]]; then
		LUA_VERSION="$(ver_cut 1-2 $(lua_get_version))"
	else
		# This is a workaround for luajit, as it confirms to lua5.1
		# and the 'GNUmakefile' doesn't understand LuaJITs version.
		LUA_VERSION="5.1"
	fi

	local myemakeargs=(
		"DESTDIR=${D}"
		"lua${LUA_VERSION/./}cpath=$(lua_get_cmod_dir)"
		"lua${LUA_VERSION/./}path=$(lua_get_lmod_dir)"
		"prefix=${EPREFIX}/usr"
	)

	emake "${myemakeargs[@]}" install${LUA_VERSION}

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	use examples && dodoc -r "examples/."
	einstalldocs
}
