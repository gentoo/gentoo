# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
SRC_URI="https://github.com/zhaozg/lua-openssl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	dev-libs/openssl:0[-bindist]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
	use luajit && LUAV=luajit || LUAV=lua
}

src_compile() {
	local pkgconfig=$(tc-getPKG_CONFIG)
	emake \
		CC="$(tc-getCC) \$(CFLAGS) -Ideps" \
		PKG_CONFIG="$pkgconfig" \
		LUA_CFLAGS="$($pkgconfig --cflags $LUAV)" \
		LUA_LIBS="$($pkgconfig --libs $LUAV)" \
		LUA_LIBDIR="$($pkgconfig --variable INSTALL_CMOD $LUAV)"
}

src_install() {
	emake \
		LUA_LIBDIR="${D}$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $LUAV)" \
		install
	einstalldocs
}
