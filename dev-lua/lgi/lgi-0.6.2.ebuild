# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lgi/lgi-0.6.2.ebuild,v 1.2 2012/11/29 16:29:47 mr_bones_ Exp $

EAPI=4

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="http://github.com/pavouk/lgi"
SRC_URI="http://github.com/downloads/pavouk/lgi/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
		x11-libs/gtk+[introspection]"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "s:^LUA_LIBDIR.*$:LUA_LIBDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua):" \
		-e "s:^LUA_SHAREDIR.*$:LUA_SHAREDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua):" \
		"${S}"/lgi/Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dohtml -r docs/*
	dodoc README.md
}
