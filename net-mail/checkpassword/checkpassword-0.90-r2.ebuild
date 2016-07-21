# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A uniform password checking interface for root applications"
HOMEPAGE="http://cr.yp.to/checkpwd.html"
SRC_URI="http://cr.yp.to/checkpwd/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static"
RESTRICT="mirror bindist"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-errno.patch
	epatch "${FILESDIR}"/${PV}-head-1.patch

	use static && append-ldflags -static
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	make || die "Error in make"
}

src_install() {
	into /
	dobin checkpassword || die
	dodoc CHANGES README TODO VERSION FILES SYSDEPS TARGETS
}
