# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/fio/fio-1.17.2.ebuild,v 1.7 2014/08/05 01:16:05 robbat2 Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="http://brick.kernel.dk/snaps/"
SRC_URI="http://brick.kernel.dk/snaps/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE=""

DEPEND="dev-libs/libaio"
RDEPEND="${DEPEND}"

src_compile() {
	append-flags -W
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" || die "emake install failed"
	dodoc README REPORTING-BUGS HOWTO
	docinto examples
	dodoc examples/*
}
