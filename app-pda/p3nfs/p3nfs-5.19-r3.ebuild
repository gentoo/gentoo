# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/p3nfs/p3nfs-5.19-r3.ebuild,v 1.1 2014/04/09 10:25:00 pinkbyte Exp $

EAPI="5"

inherit eutils flag-o-matic

DESCRIPTION="Symbian to Unix and Linux communication program"
HOMEPAGE="http://www.koeniglich.de/p3nfs.html"
SRC_URI="http://www.koeniglich.de/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="|| ( net-nds/portmap net-nds/rpcbind )"

src_prepare() {
	sed -i "s:.*cd client/epoc32.*:#&:" "${S}/Makefile.in" || die
	sed -i "s:\$(LDFLAGS):${LDFLAGS}:" "${S}/server/Makefile.in" || die
	append-flags -fno-strict-aliasing # fix QA issues
	# bug #314971
	epatch "${FILESDIR}/${P}-set-default-tty.patch"
	epatch_user
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall -I." || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" DOCDIR="${D}/usr/share/doc/${PF}" install
	dodoc README
}

pkg_postinst() {
	elog
	elog "You need to install one of the nfsapp-*.sis clients on your"
	elog "Symbian device to be able to mount it's filesystems."
	elog
	elog "Make sure to have portmap or rpcbind service running"
	elog "before you start the p3nfsd server."
	elog
}
