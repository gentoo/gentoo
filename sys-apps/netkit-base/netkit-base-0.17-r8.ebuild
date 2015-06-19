# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/netkit-base/netkit-base-0.17-r8.ebuild,v 1.18 2011/04/16 19:13:52 ulm Exp $

inherit eutils

DESCRIPTION="Old-style inetd"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/*.patch
}

src_compile() {
	./configure || die

	cp MCONFIG MCONFIG.orig
	#sed -e "s/-O2/${CFLAGS}  -Wstrict-prototypes -fomit-frame-pointer/"
	sed -e "s:^CFLAGS=.*:CFLAGS=${CFLAGS} -Wall -Wbad-function-cast -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Winline:" \
		MCONFIG.orig > MCONFIG

	emake || die "compile problem"
}

src_install() {
	sed -i \
		-e 's:in\.telnetd$:in.telnetd -L /usr/sbin/telnetlogin:' \
		etc.sample/inetd.conf

	dosbin inetd/inetd
	doman inetd/inetd.8
	newinitd "${FILESDIR}"/inetd.rc6 inetd

	dodoc BUGS ChangeLog README
	docinto samples ; dodoc etc.sample/*
}
