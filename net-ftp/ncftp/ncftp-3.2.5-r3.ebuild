# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ncftp/ncftp-3.2.5-r3.ebuild,v 1.10 2014/03/19 15:14:02 ago Exp $

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="http://www.ncftp.com/"
SRC_URI="
	ftp://ftp.${PN}.com/${PN}/${P}-src.tar.bz2 -> ${P}.474.tar.bz2
	mirror://openbsd/distfiles/${P//.}-v6.diff.gz
"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="ipv6 pch"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/.474}

src_prepare() {
	epatch "${WORKDIR}"/${P//.}-v6.diff
	tc-export CC
	sed -i \
		-e "s:CC=gcc:CC ?= ${CC}:" \
		-e 's:@SFLAG@::' \
		-e 's:@STRIP@:true:' \
		Makefile.in */Makefile.in || die
	AT_M4DIR=autoconf_local/ eautoreconf
}

src_configure() {
	LC_ALL="C" \
	LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses)" \
		econf \
		$(use_enable ipv6) \
		$(use_enable pch precomp) \
		--disable-ccdv \
		--disable-universal
}

src_install() {
	default
	dodoc README.txt doc/*.txt
	dohtml doc/html/*.html
}
