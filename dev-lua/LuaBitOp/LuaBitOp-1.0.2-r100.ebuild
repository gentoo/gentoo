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

	multilib_copy_sources
}

lua_multilib_src_compile() {
	# Clean project, to compile it for every lua slot
	emake clean

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"CCOPT="
		"INCLUDES=$(lua_get_CFLAGS)"
	)

	emake "${myemakeargs[@]}" all

	# Copy module to match the choosen LUA implementation
	cp "bit.so" "${S}/bit-${ELUA}.so" || die
}

multilib_src_compile() {
	lua_foreach_impl lua_multilib_src_compile
}

lua_multilib_src_test() {
	local mytests=(
		"bitbench.lua"
		"bittest.lua"
		"md5test.lua"
		"nsievebits.lua"
	)

	for mytest in ${mytests[@]}; do
		LUA_CPATH="${S}/bit-${ELUA}.so" ${ELUA} ${mytest}
	done
}

multilib_src_test() {
	multilib_is_native_abi && lua_foreach_impl lua_multilib_src_test
}

lua_multilib_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "${S}/bit-${ELUA}.so" "bit.so" || die

	exeinto $(lua_get_cmod_dir)
	doexe bit.so
}

multilib_src_install() {
	lua_foreach_impl lua_multilib_src_install
}

multilib_src_install_all() {
	einstalldocs
}
