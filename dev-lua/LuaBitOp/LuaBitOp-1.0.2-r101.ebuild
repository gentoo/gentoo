# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} )

inherit lua multilib-minimal toolchain-funcs

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "doc/." )

src_prepare() {
	default

	lua_copy_sources
	lua_foreach_impl multilib_copy_sources
}

lua_multilib_src_compile() {
	pushd "${WORKDIR}/${P}-${ELUA/./-}-${MULTILIB_ABI_FLAG}.${ABI}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CCOPT="
		"INCLUDES=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}" all

	popd
}

multilib_src_compile() {
	lua_foreach_impl lua_multilib_src_compile
}

lua_multilib_src_test() {
	pushd "${WORKDIR}/${P}-${ELUA/./-}-${MULTILIB_ABI_FLAG}.${ABI}" || die

	local mytests=(
		"bitbench.lua"
		"bittest.lua"
		"md5test.lua"
		"nsievebits.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="./?.so" ${ELUA} ${mytest}
	done

	popd
}

multilib_src_test() {
	multilib_is_native_abi && lua_foreach_impl lua_multilib_src_test
}

lua_multilib_src_install() {
	pushd "${WORKDIR}/${P}-${ELUA/./-}-${MULTILIB_ABI_FLAG}.${ABI}" || die

	exeinto $(lua_get_cmod_dir)
	doexe bit.so

	popd
}

multilib_src_install() {
	lua_foreach_impl lua_multilib_src_install
}

multilib_src_install_all() {
	einstalldocs
}
