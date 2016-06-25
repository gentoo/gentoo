# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="Utility to change hard drive performance parameters"
HOMEPAGE="http://sourceforge.net/projects/hdparm/"
SRC_URI="mirror://sourceforge/hdparm/${P}.tar.gz"

LICENSE="BSD GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sysmacros.patch #580052
	use static && append-ldflags -static
	sed -i \
		-e "/^CFLAGS/ s:-O2:${CFLAGS}:" \
		-e "/^LDFLAGS/ s:-s:${LDFLAGS}:" \
		Makefile || die "sed"
}

src_compile() {
	emake STRIP=: CC="$(tc-getCC)"
}

src_install() {
	into /
	dosbin hdparm contrib/idectl

	newinitd "${FILESDIR}"/hdparm-init-8 hdparm
	newconfd "${FILESDIR}"/hdparm-conf.d.3 hdparm

	doman hdparm.8
	dodoc hdparm.lsm Changelog README.acoustic hdparm-sysconfig
	docinto wiper
	dodoc wiper/{README.txt,wiper.sh}
}
