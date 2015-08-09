# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib toolchain-funcs flag-o-matic eutils

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="http://www.keplerproject.org/luaexpat/"
SRC_URI="http://matthewwild.co.uk/projects/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1[deprecated]
	dev-libs/expat"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	append-flags -fPIC
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		LUA_LDIR="$(pkg-config --variable INSTALL_LMOD lua)" \
		LUA_CDIR="$(pkg-config --variable INSTALL_CMOD lua)" \
		LUA_INC="-I$(pkg-config --variable INSTALL_INC lua)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LUA_LDIR="$(pkg-config --variable INSTALL_LMOD lua)" \
		LUA_CDIR="$(pkg-config --variable INSTALL_CMOD lua)" \
		LUA_INC="-I$(pkg-config --variable INSTALL_INC lua)" \
		install
	dodoc README
	dohtml -r doc/*
}
