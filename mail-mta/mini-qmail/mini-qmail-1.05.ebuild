# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/mini-qmail/mini-qmail-1.05.ebuild,v 1.16 2013/02/28 17:50:48 zx2c4 Exp $

inherit eutils toolchain-funcs fixheadtails user

DESCRIPTION="a small null client that forwards mail via QMQP to a full qmail server"
HOMEPAGE="http://www.qmail.org/ http://cr.yp.to/qmail/mini.html"
SRC_URI="mirror://qmail/netqmail-${PV}.tar.gz
	http://www.din.or.jp/~ushijima/mini-qmail-kit/mini-qmail-kit-0.52.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc x86"
IUSE=""

DEPEND="sys-apps/groff"
RDEPEND="
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp
	!mail-mta/opensmtpd
	"

S=${WORKDIR}/netqmail-${PV}/netqmail-${PV}

pkg_setup() {
	# keep in sync with qmail pkg
	enewgroup qmail 201
	enewuser alias 200 -1 /var/qmail/alias 200
	enewuser qmaild 201 -1 /var/qmail 200
	enewuser qmaill 202 -1 /var/qmail 200
	enewuser qmailp 203 -1 /var/qmail 200
	enewuser qmailq 204 -1 /var/qmail 201
	enewuser qmailr 205 -1 /var/qmail 201
	enewuser qmails 206 -1 /var/qmail 201
}

src_unpack() {
	unpack netqmail-${PV}.tar.gz
	unpack mini-qmail-kit-0.52.tar.gz

	cd netqmail-${PV}
	./collate.sh || die "patching failed"
	mv "${WORKDIR}"/mini-qmail-kit-0.52/* "${S}"/

	cd "${S}"
	echo -n "$(tc-getCC) ${CFLAGS}" > "${S}"/conf-cc
	echo -n "$(tc-getCC) ${LDFLAGS}" > "${S}"/conf-ld
	ht_fix_file "${S}"/Makefile

	epatch "${FILESDIR}"/${PV}-config-mini-help.patch
}

src_compile() {
	emake it man || die
}

src_install() {
	einfo "Setting up directory hierarchy ..."
	keepdir /var/mini-qmail/control

	dodoc FAQ UPGRADE SENDMAIL INSTALL* TEST* REMOVE* PIC* SECURITY
	dodoc SYSDEPS TARGETS THANKS THOUGHTS TODO VERSION README*

	exeinto /var/mini-qmail/bin
	doexe qmail-qmqpc forward qmail-inject \
		sendmail predate datemail mailsubj \
		qmail-showctl maildirmake maildir2mbox \
		maildirwatch qail elq pinq \
		|| die "doexe failed"
	dosym qmail-qmqpc /var/mini-qmail/bin/qmail-queue
	newexe config-mini.sh config-mini
	dosed "s:QMAIL:/var/mini-qmail/:g" /var/mini-qmail/bin/config-mini

	doman qmail-qmqpc.8 forward.1 qmail-inject.8 \
		mailsubj.1 qmail-showctl.8 maildirmake.1 \
		maildir2mbox.1 maildirwatch.1 qmail-queue.8 \
		qmail.7

	einfo "Adding env.d entry for qmail"
	doenvd "${FILESDIR}"/99qmail

	einfo "Creating sendmail replacement ..."
	diropts -m 755
	dodir /usr/sbin /usr/lib
	dosym /var/mini-qmail/bin/sendmail /usr/sbin/sendmail
	dosym /var/mini-qmail/bin/sendmail /usr/lib/sendmail
}

pkg_postinst() {
	elog "In order for mini-qmail to work, you need to setup"
	elog "the QMQP server information."
	elog
	elog "You can setup the values in /var/mini-qmail/control yourself,"
	elog "or use the utility /var/mini-qmail/bin/config-mini"
	elog "To find out what values to put in what files, see the install"
	elog "section of http://cr.yp.to/qmail/mini.html"
}
