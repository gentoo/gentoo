# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs multilib

DESCRIPTION="qmail-queue multi-filter front end"
SRC_URI="http://untroubled.org/qmail-qfilter/archive/${P}.tar.gz"
HOMEPAGE="http://untroubled.org/qmail-qfilter/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.106"
RDEPEND="${DEPEND} virtual/qmail"

QMAIL_BINDIR="/var/qmail/bin/"

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
	echo "${D}${QMAIL_BINDIR}" > conf-bin
	echo "${D}/usr/share/man/" > conf-man
	echo "/usr/include/bglibs" > conf-bgincs
	echo "/usr/$(get_libdir)/bglibs" > conf-bglibs
}

src_install () {
	dodir ${QMAIL_BINDIR} /usr/share/man/
	emake install || die "Installer failed"
	dodoc ANNOUNCEMENT NEWS README TODO
	docinto samples
	dodoc samples/*
}

pkg_postinst() {
	elog "Please see /usr/share/doc/${PF}/README* for configuration information"
}
