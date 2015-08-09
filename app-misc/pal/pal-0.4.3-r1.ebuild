# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils prefix toolchain-funcs

DESCRIPTION="pal command-line calendar program"
HOMEPAGE="http://palcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/palcal/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.0
	nls? ( virtual/libintl )
	sys-libs/ncurses
	sys-libs/readline
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

S=${WORKDIR}/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PV}-strip.patch
	epatch "${FILESDIR}"/${PV}-ldflags.patch
	epatch "${FILESDIR}"/${P}-pkg_config.patch
	epatch "${FILESDIR}"/${P}-prefix.patch

	eprefixify Makefile.defs input.c Makefile
	sed -i -e 's/ -o root//g' {.,convert}/Makefile || die

	tc-export PKG_CONFIG
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${CFLAGS}" LDOPT="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install-man install-bin install-share

	if use nls; then
		emake DESTDIR="${D}" install-mo
	fi

	dodoc "${WORKDIR}"/${P}/{ChangeLog,doc/example.css}
}
