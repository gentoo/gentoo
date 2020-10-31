# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
SRC_URI="https://github.com/keplerproject/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc luajit test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/lua-5.1:*
	luajit? ( dev-lang/luajit:2 )"
BDEPEND="
	virtual/pkgconfig
	test? ( ${RDEPEND} )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	cat > config <<-EOF
		# Installation directories

		# Default installation prefix
		PREFIX="$($(tc-getPKG_CONFIG) --variable exec_prefix $(usex luajit 'luajit' 'lua'))"

		# System's libraries directory (where binary libraries are installed)
		LUA_LIBDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"

		# Lua includes directory
		LUA_INC=-I$(pwd)/src
		LUA_INC+=-I$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))

		# OS dependent
		LIB_OPTION=\$(LDFLAGS) -shared

		LIBNAME=$T.so.$V

		# Compilation directives
		WARN=-O2 -Wall -fPIC -W -Waggregate-return -Wcast-align -Wmissing-prototypes -Wnested-externs -Wshadow -Wwrite-strings -pedantic
		INCS=\$(LUA_INC)
		CFLAGS+=\$(WARN) \$(INCS)
		CC=$(tc-getCC)
	EOF
}

src_test() {
	LUA_CPATH=./src/?.so $(usex luajit 'luajit' 'lua') tests/test.lua || die
}

src_install() {
	use doc && local HTML_DOCS=( doc/us/. )
	einstalldocs

	emake DESTDIR="${D}" install
}
