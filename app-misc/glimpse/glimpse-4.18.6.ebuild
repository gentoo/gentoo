# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glimpse/glimpse-4.18.6.ebuild,v 1.1 2013/02/04 08:11:40 patrick Exp $

EAPI="5"

inherit flag-o-matic eutils

DESCRIPTION="A index/query system to search a large set of files quickly"
HOMEPAGE="http://webglimpse.net/"
SRC_URI="http://webglimpse.net/trial/${P}.tar.gz"

LICENSE="glimpse"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="static"

RDEPEND="!dev-libs/tre
	!app-text/agrep"

src_prepare() {
	sed -i \
		-e "s:CC=.*:CC=$(tc-getCC):" \
		-e 's:-O3 -fomit-frame-pointer:$(OPTIMIZEFLAGS):' \
		dynfilters/Makefile.in \
		|| die "removing -O3 failed"
	sed -i \
		-e '/^CFLAGS/s:$: $(OPTIMIZEFLAGS):' \
		{agrep,compress,index}/Makefile.in \
		libtemplate/{template,util}/Makefile.in \
		|| die "inserting OPTIMIZEFLAGS failed"
	sed -i \
		-e 's:$(mandir):&/man1/:' \
		agrep/Makefile.in \
		|| die "adding man1 to man install dir failed"

	sed -i \
		-e '/^LDFLAGS/d' \
		{agrep,compress,index}/Makefile.in \
		|| die "LDFLAGS sed failed"

	epatch "${FILESDIR}"/${PN}-4.18.5-makefile.patch
}

src_configure() {
	use static && append-ldflags -static

	econf || die
}

src_compile() {
	emake OPTIMIZEFLAGS="${CFLAGS}" || die
}

src_install() {
	einstall || die
}
