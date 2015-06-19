# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luaexpat/luaexpat-1.3.0-r1.ebuild,v 1.9 2015/05/15 07:39:48 pacho Exp $

EAPI=5

inherit multilib toolchain-funcs flag-o-matic eutils multilib-minimal

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="http://www.keplerproject.org/luaexpat/"
SRC_URI="http://matthewwild.co.uk/projects/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1.5-r2[deprecated,${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

src_prepare() {
	multilib_copy_sources

	append-flags -fPIC
}

multilib_src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		LUA_LDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		LUA_CDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		LUA_INC="-I$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		LUA_LDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		LUA_CDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		LUA_INC="-I$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)" \
		install
}

multilib_src_install_all() {
	dodoc README
	dohtml -r doc/*
}
