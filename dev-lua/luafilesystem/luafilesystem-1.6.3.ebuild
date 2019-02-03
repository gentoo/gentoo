# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_PV=${PV//./_}

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
SRC_URI="https://github.com/keplerproject/luafilesystem/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

HTML_DOCS=( doc/us )

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	sed -i \
		-e "s|-O2|${CFLAGS}|" \
		-e "/^LIB_OPTION/s|= |= ${LDFLAGS} |" \
		config || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		INCS="-I$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
}

src_test() {
	LUA_CPATH=./src/?.so $(usex luajit 'luajit' 'lua') tests/test.lua
}

src_install() {
	emake \
		LUA_LIBDIR="${ED%/}$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))" \
		install

	einstalldocs
}
