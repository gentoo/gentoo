# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="library for calling real mode BIOS routines under Linux"
HOMEPAGE="http://www.sourceforge.net/projects/lrmi/"
SRC_URI="mirror://sourceforge/lrmi/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-kernel-2.6.26.patch
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	tc-export CC AR RANLIB
	emake CFLAGS="${CFLAGS} -Wall" LDFLAGS="${LDFLAGS}" || die "emake failed."
}

src_install() {
	dobin vbetest || die "dobin failed."
	dolib.a liblrmi.a || die "dolib.a failed."
	dolib.so liblrmi.so.${PV} || die "dolib.so failed."
	dosym liblrmi.so.${PV} /usr/lib/liblrmi.so
	dosym liblrmi.so.${PV} /usr/lib/liblrmi.so.${PV%%.*}

	insinto /usr/include
	doins lrmi.h vbe.h || die "doins failed."
}
