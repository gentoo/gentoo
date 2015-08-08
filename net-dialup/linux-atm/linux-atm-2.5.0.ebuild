# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils libtool flag-o-matic toolchain-funcs

DESCRIPTION="Tools for ATM"
HOMEPAGE="http://linux-atm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/yacc"

RESTRICT="test"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-glibc28.patch
	epatch "${FILESDIR}"/${P}-bison24.patch

	sed -i '/#define _LINUX_NETDEVICE_H/d' \
		src/arpd/*.c || die "sed command on arpd/*.c files failed"
	sed -i 's:cp hosts.atm /etc:cp hosts.atm ${DESTDIR}/etc:' \
		src/config/Makefile.in || die "sed command on Makefile.in failed"

	elibtoolize
}

src_compile() {
	append-flags -fno-strict-aliasing

	CC_FOR_BUILD=$(tc-getCC) econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc README NEWS THANKS AUTHORS BUGS ChangeLog
	dodoc doc/README* doc/atm*
}
