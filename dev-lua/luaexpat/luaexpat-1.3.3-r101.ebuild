# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
LUA_REQ_USE="${MULTILIB_USEDEP}"

inherit lua multilib-minimal toolchain-funcs

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="https://github.com/tomasguisasola/luaexpat"
SRC_URI="https://github.com/tomasguisasola/luaexpat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
	lua_foreach_impl multilib_copy_sources
}

lua_multilib_src_compile() {
	pushd "${WORKDIR}/${P}-${ELUA/./-}-${MULTILIB_ABI_FLAG}.${ABI}" || die

	local myemakeargs=(
		"CC=$(tc-getCC) ${CFLAGS}"
		"LUA_INC=$(lua_get_include_dir)"
	)

	emake "${myemakeargs[@]}"

	popd
}

multilib_src_compile() {
	lua_foreach_impl lua_multilib_src_compile
}

lua_multilib_src_install() {
	pushd "${WORKDIR}/${P}-${ELUA/./-}-${MULTILIB_ABI_FLAG}.${ABI}" || die

	local myemakeargs=(
		"LUA_DIR=${ED}/$(lua_get_lmod_dir)"
		"LUA_INC=${ED}/$(lua_get_include_dir)"
		"LUA_LIBDIR=${ED}/$(lua_get_cmod_dir)"
	)

	emake "${myemakeargs[@]}" install

	popd
}

multilib_src_install() {
	lua_foreach_impl lua_multilib_src_install
}

multilib_src_install_all() {
	einstalldocs
}
