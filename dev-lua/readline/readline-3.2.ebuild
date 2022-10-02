# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A simple interface to the readline and history libraries"
HOMEPAGE="https://pjb.com.au/comp/lua/readline.html"
SRC_URI="https://pjb.com.au/comp/lua/${P}.tar.gz -> lua-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Tests are interactive
RESTRICT="test"

RDEPEND="
	dev-lua/luaposix
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local compiler=(
		"$(tc-getCC)"
		"${CFLAGS}"
		"-fPIC"
		"$(lua_get_CFLAGS)"
		"-c C-readline.c"
		"-o C-readline.o"
	)
	einfo "${compiler[@]}"
	${compiler[@]} || die

	local linker=(
		"$(tc-getCC)"
		"-shared"
		"${LDFLAGS}"
		"$($(tc-getPKG_CONFIG) --libs readline)"
		"-o C-readline.so"
		"C-readline.o"
	)
	einfo "${linker[@]}"
	${linker[@]} || die

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" || die
	LUA_CPATH="./?.so;${ESYSROOT}/usr/$(get_libdir)/lua/$(ver_cut 1-2 $(lua_get_version))/?.so" ${ELUA} test/test_rl.lua || die
	popd || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	insinto "$(lua_get_cmod_dir)"
	doins C-readline.so

	insinto "$(lua_get_lmod_dir)"
	doins readline.lua

	popd || die
}

src_install() {
	lua_foreach_impl lua_src_install

	docinto html
	dodoc doc/readline.html
}
