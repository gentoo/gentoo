# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="https://github.com/tomasguisasola/luaexpat"
SRC_URI="https://github.com/tomasguisasola/luaexpat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/expat
	${LUA_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/us/." )

PATCHES=(
	"${FILESDIR}/${P}_makefile.patch"
	"${FILESDIR}/${P}_getcurrentbytecount.patch"
	"${FILESDIR}/${P}_restore_functionality.patch"
)

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O2//g' -i makefile || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC) ${CFLAGS}"
		"LUA_INC=$(lua_get_include_dir)"
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
		"LUA_DIR=${ED}/$(lua_get_lmod_dir)"
		"LUA_INC=${ED}/$(lua_get_include_dir)"
		"LUA_LIBDIR=${ED}/$(lua_get_cmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
