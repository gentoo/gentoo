# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/fio/fio-2.0.14-r1.ebuild,v 1.8 2014/09/07 17:42:56 robbat2 Exp $

EAPI="4"

inherit toolchain-funcs flag-o-matic eutils

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="http://brick.kernel.dk/snaps/"
SRC_URI="http://brick.kernel.dk/snaps/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc ppc64 x86"
IUSE=""

DEPEND="dev-libs/libaio"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i \
		-e '/filter /s:-o:$(LDFLAGS) -o:' \
		-e '/: depend$/d' \
		-e '/^DEBUGFLAGS/s, -D_FORTIFY_SOURCE=2,,g' \
		Makefile || die
	epatch "$FILESDIR"/fio-2.0.14-pic-clobber-fix.patch
}

src_configure() {
	chmod g-w "${T}"
	: # not a real configure script
	./configure --extra-cflags="${CFLAGS}" --cc="$(tc-getCC)"
}

src_compile() {
	append-flags -W
	emake V=1
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" mandir="/usr/share/man"
	dodoc README REPORTING-BUGS HOWTO
	docinto examples
	dodoc examples/*
	doman fio.1
}
