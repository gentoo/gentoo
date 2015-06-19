# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lgi/lgi-0.7.2.ebuild,v 1.8 2015/06/11 01:10:11 robbat2 Exp ${PV}.ebuild,v 1.7 2015/04/02 18:22:41 mr_bones_ Exp $

EAPI=4

VIRTUALX_REQUIRED="manual"

inherit eutils toolchain-funcs flag-o-matic virtualx

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="http://github.com/pavouk/lgi"
SRC_URI="https://github.com/pavouk/lgi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="examples test"

RDEPEND=">=dev-lang/lua-5.1
		dev-libs/gobject-introspection
		dev-libs/glib
		virtual/libffi"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		test? (
			x11-libs/cairo[glib]
			x11-libs/gtk+[introspection]
			${VIRTUALX_DEPEND}
		)"

src_prepare() {
	sed -i \
		-e "s:^LUA_LIBDIR.*$:LUA_LIBDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua):" \
		-e "s:^LUA_SHAREDIR.*$:LUA_SHAREDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua):" \
		"${S}"/lgi/Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}"
}

src_test() {
	Xemake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}" check
}

src_install() {
	emake DESTDIR="${D}" install
	dohtml -r docs/*
	dodoc README.md
	if use examples; then
		dodoc -r samples
	fi
}
