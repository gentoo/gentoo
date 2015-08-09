# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

GENQMAIL_PV=20080406

inherit eutils qmail

DESCRIPTION="a small null client that forwards mail via QMQP to a full qmail server"
HOMEPAGE="
	http://netqmail.org
	http://cr.yp.to/qmail/mini.html
	http://qmail.org
"
SRC_URI="mirror://qmail/netqmail-${PV}.tar.gz
	http://dev.gentoo.org/~hollow/distfiles/${GENQMAIL_F}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 arm hppa ~mips ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/maildrop
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp
	!mail-mta/opensmtpd
	${DEPEND}
	"

S="${WORKDIR}"/netqmail-${PV}

src_unpack() {
	genqmail_src_unpack

	unpack netqmail-${PV}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-headers.patch

	qmail_src_postunpack
}

src_compile() {
	qmail_src_compile
}

# make check is actually an install-check target, see bug #364955
src_test() { :; }

qmail_base_install_hook() {
	dosym qmail-qmqpc "${QMAIL_HOME}"/bin/qmail-queue
	exeinto "${QMAIL_HOME}"/bin
	doexe "${FILESDIR}"/config-mini
}

src_install() {
	qmail_base_install
	qmail_man_install
	qmail_sendmail_install
}
