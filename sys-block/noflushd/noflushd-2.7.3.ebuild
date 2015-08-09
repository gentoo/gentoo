# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A daemon to spin down your disks and force accesses to be cached"
HOMEPAGE="http://noflushd.sourceforge.net"
SRC_URI="mirror://sourceforge/noflushd/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc"
IUSE=""
SLOT="0"

src_compile() {
	./configure --prefix=/usr \
		--host=${CHOST} \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-docdir=/usr/share/doc/${PF} || die "configure problem"
	emake || die "compile problem"
}

src_install () {
	dosbin src/noflushd
	doman man/noflushd.8
	dodoc README NEWS

	newinitd "${FILESDIR}"/noflushd.rc6 noflushd
	newconfd "${FILESDIR}"/noflushd.confd noflushd
}

pkg_postinst() {
	einfo 'Run "rc-update add noflushd default" to add it to the'
	einfo "default runlevel."

	ewarn "noflushd works with IDE devices only."
	ewarn "It has possible problems with reiserfs, too."
}
