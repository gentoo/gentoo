# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sendfile/sendfile-2.1b-r1.ebuild,v 1.4 2012/06/28 10:05:34 ago Exp $

inherit toolchain-funcs

DESCRIPTION="SAFT implementation for UNIX and serves as a tool for asynchronous sending of files in the Internet"
HOMEPAGE="http://fex.rus.uni-stuttgart.de/saft/sendfile.html"
SRC_URI="http://fex.rus.uni-stuttgart.de/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="virtual/inetd"

src_compile() {
	./makeconfig \
		"CFLAGS=\"${CFLAGS}\" \
		CC=$(tc-getCC) \
		LDFLAGS=\"${LDFLAGS}\" \
		BINDIR=/usr/bin \
		MANDIR=/usr/share/man \
		CONFIG=/etc/sendfile \
		SERVERDIR=/usr/sbin" || die "./makeconfig failed"

	make all || die "make all failed"
}

src_install() {
	into /usr
	dosbin src/sendfiled
	dobin etc/check_sendfile src/sendfile src/sendmsg src/receive src/fetchfile
	dobin src/utf7encode src/wlock etc/sfconf etc/sfdconf
	dosym /usr/bin/utf7encode /usr/bin/utf7decode

	dodir /etc/sendfile
	dodir /var/spool/sendfile
	dodir /var/spool/sendfile/LOG
	dodir /var/spool/sendfile/OUTGOING
	fperms 0700 /var/spool/sendfile/LOG
	fperms 1777 /var/spool/sendfile/OUTGOING

	insinto /etc/sendfile
	doins etc/sendfile.deny etc/sendfile.cf

	insinto /etc/xinetd.d
	doins "${FILESDIR}/sendfiled" || die

	doman doc/sendmsg.1 doc/sendfile.1 doc/receive.1 doc/fetchfile.1

	dodoc doc/AUTHORS doc/ChangeLog doc/README* doc/THANKS
}

pkg_postinst() {
	einfo "To start the sendfile daemon you have to start xinetd"
}
