# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/drac/drac-1.12-r1.ebuild,v 1.16 2014/08/10 21:17:31 slyfox Exp $

inherit toolchain-funcs

DESCRIPTION="A robust implementation of POP-before-SMTP"
HOMEPAGE="http://mail.cc.umanitoba.ca/drac/"
SRC_URI="ftp://ftp.cc.umanitoba.ca/src/${PN}.tar.Z"

LICENSE="rc"
SLOT="0"
KEYWORDS="x86 sparc ppc hppa ~amd64 ppc64"
IUSE="debug"

DEPEND="virtual/mta
	>=sys-libs/db-3.2.9
	>=sys-apps/sed-4"
RDEPEND="${DEPEND}
	>=net-nds/portmap-5b-r6"

S="${WORKDIR}"

src_compile() {
	local mysed
	if use debug ; then
		mysed="s:^CFLAGS.*:CFLAGS = \$(DEFS) -g ${CFLAGS}:"
	else
		mysed="s:^CFLAGS.*:CFLAGS = \$(DEFS) ${CFLAGS}:"
	fi

	sed -e "s:^INSTALL = .*:INSTALL = /usr/bin/install:" \
		-e "s:^EBIN = .*:EBIN = /usr/sbin:" \
		-e "s:^MAN = .*:MAN = /usr/share/man/man:" \
		-e "s:^DEFS = .*:DEFS = -DSOCK_RPC -DFCNTL_LOCK -DGETHOST -DDASH_C:" \
		-e "s:^CC = .*:CC = $(tc-getCC):" \
		-e "s:^LDLIBS = .*:LDLIBS = -ldb:" \
		-e "s:^TSTLIBS = .*:TSTLIBS = -L. -ldrac:" \
		-e "s:^RPCGENFLAGS = .*:RPCGENFLAGS = -C -I:" \
		-e "s:^MANADM = .*:MANADM = 8:" \
		-e "${mysed}" \
		-i Makefile || die "sed failed"

	# Parallel build does not work.
	emake -j1 || die "compile problem"
}

src_install() {
	newsbin rpc.dracd dracd
	dosbin "${FILESDIR}/drac_rotate"

	dolib.a libdrac.a

	newinitd "${FILESDIR}/dracd.rc6" dracd

	dodoc Changes COPYRIGHT INSTALL PORTING README
	newman rpc.dracd.1m dracd.8
	doman dracauth.3

	keepdir /var/lib/drac
	fowners mail:mail /var/lib/drac
	fperms 750 /var/lib/drac
}

pkg_postinst() {
	elog "After configuring your IMAP/POP server for DRAC, and starting the"
	elog "dracd server (e.g. by running /etc/init.d/dracd start) you can"
	elog "set up your MTA to check for authenticated hosts in:"
	elog "   /var/lib/drac/drac"
	elog "Please see the MTA documentation for more details."
	echo
}
