# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs fixheadtails

MINI_VER=0.52
DESCRIPTION="a small null client that forwards mail via QMQP to a full qmail server"
HOMEPAGE="http://www.qmail.org/ http://cr.yp.to/qmail/mini.html"
SRC_URI="mirror://qmail/netqmail-${PV}.tar.gz
	http://www.din.or.jp/~ushijima/mini-qmail-kit/mini-qmail-kit-${MINI_VER}.tar.gz"

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

S=${WORKDIR}/mini-qmail-kit-${MINI_VER}

src_unpack() {
	unpack netqmail-${PV}.tar.gz
	unpack mini-qmail-kit-${MINI_VER}.tar.gz

	cd "${S}"
	epatch "${FILESDIR}"/${PV}-config-mini-help.patch
	sed -i \
		-e "/^qmail=/s:=.*:=${WORKDIR}/netqmail-${PV}/netqmail-${PV}:" \
		Makefile.mini || die

	cd "${WORKDIR}"/netqmail-${PV}
	./collate.sh || die "patching failed"

	cd netqmail-${PV}
	echo -n "$(tc-getCC) ${CFLAGS}" > "${S}"/conf-cc
	echo -n "$(tc-getCC) ${LDFLAGS}" > "${S}"/conf-ld
	ht_fix_file Makefile
}

src_compile() {
	emake -f Makefile.mini || die "mini prep failed"
	emake mini || die "make mini failed"
}

src_install() {
	einfo "Setting up directory hierarchy ..."
	keepdir /var/mini-qmail/control

	dodoc INSTALL README

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
