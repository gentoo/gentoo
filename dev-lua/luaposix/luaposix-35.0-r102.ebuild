# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Bindings for POSIX APIs"
HOMEPAGE="https://luaposix.github.io/luaposix/ https://github.com/luaposix/luaposix"
SRC_URI="https://github.com/luaposix/luaposix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Requires specl, which is not in the tree yet
RESTRICT="test"

DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}
	lua_targets_lua5-1? ( dev-lua/lua-bit32[lua_targets_lua5-1(-)] )
	lua_targets_luajit? ( dev-lua/lua-bit32[lua_targets_luajit(-)] )
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Temporary fix for respect LDFLAGS (#739050)
	# Fixed in luke 0.2.1
	sed -i -e "s:c_module,libdirs:c_module,'\$LDFLAGS',libdirs:g" \
		build-aux/luke || die

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	# LDOC=true means disable ldoc update documentation
	./build-aux/luke --verbose package="${PN}" version="${PV}" \
		LDOC=true \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$(lua_get_cmod_dir)" \
		INST_LUADIR="${ED}/$(lua_get_lmod_dir)" \
		LUA_INCDIR="${EPREFIX}/$(lua_get_include_dir)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" || die

	popd || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	./build-aux/luke install \
		LDOC=true \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$(lua_get_cmod_dir)" \
		INST_LUADIR="${ED}/$(lua_get_lmod_dir)" \
		|| die

	popd || die
}

src_install() {
	lua_foreach_impl lua_src_install
	dodoc {NEWS,README}.md
	use doc && dodoc -r doc
}
