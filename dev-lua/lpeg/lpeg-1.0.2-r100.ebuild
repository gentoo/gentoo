# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua flag-o-matic toolchain-funcs

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS=( "lpeg.html" "lpeg-128.gif" "re.html" )

PATCHES=( "${FILESDIR}/${PN}-1.0.2-makefile.patch" )

src_prepare() {
	default

	use debug && append-cflags -DLPEG_DEBUG
}

lua_src_compile() {
	# Clean project to compile it for every lua slot
	emake clean

	local myemakeargs=(
		CC="$(tc-getCC)"
		LUADIR="$(lua_get_include_dir)"
	)

	emake "${myemakeargs[@]}"

	# Copy module to match the choosen LUA implementation
	cp "lpeg.so" "lpeg-${ELUA}.so" || die
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_test() {
	LUA_CPATH="${S}/lpeg-${ELUA}.so" ${ELUA} test.lua || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	# Use correct module for the choosen LUA implementation
	cp "lpeg-${ELUA}.so" "lpeg.so" || die

	exeinto $(lua_get_cmod_dir)
	doexe lpeg.so

	insinto $(lua_get_lmod_dir)
	doins re.lua
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
