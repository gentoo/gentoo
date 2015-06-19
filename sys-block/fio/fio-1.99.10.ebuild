# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/fio/fio-1.99.10.ebuild,v 1.3 2014/09/07 17:42:56 robbat2 Exp $

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="http://brick.kernel.dk/snaps/"
SRC_URI="http://brick.kernel.dk/snaps/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="dev-libs/libaio"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i \
		-e '/filter /s:-o:$(LDFLAGS) -o:' \
		-e '/: depend$/d' \
		Makefile || die
}

src_compile() {
	append-flags -W
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" prefix="/usr" mandir="/usr/share/man" || die "emake install failed"
	dodoc README REPORTING-BUGS HOWTO
	docinto examples
	dodoc examples/*
	doman fio.1
}
