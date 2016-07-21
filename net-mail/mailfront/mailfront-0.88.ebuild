# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit fixheadtails toolchain-funcs

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="http://untroubled.org/mailfront/"
SRC_URI="http://untroubled.org/mailfront/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ~ppc"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.006"
RDEPEND="
	${DEPEND}
	net-libs/cvm
	virtual/qmail
"

src_unpack() {
	unpack ${A}
	ht_fix_file "${S}"/Makefile
}

src_compile() {
	echo "/usr/lib/bglibs/include" > conf-bgincs
	echo "/usr/lib/bglibs/lib" > conf-bglibs
	echo "/var/qmail/bin" > conf-bin
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) " > conf-ld
	emake || die
}

src_install() {
	exeinto /var/qmail/bin
	doexe pop3front-auth pop3front-maildir smtpfront-echo \
		smtpfront-qmail smtpfront-reject imapfront-auth \
		qmqpfront-qmail qmtpfront-qmail || die

	#install new run files for qmail-smtpd and qmail-pop3
	exeinto /var/qmail/supervise/qmail-smtpd
	newexe "${FILESDIR}"/run-smtpfront run.mailfront
	exeinto /var/qmail/supervise/qmail-pop3d
	newexe "${FILESDIR}"/run-pop3front run.mailfront

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION

	dohtml cvm-sasl.html imapfront.html mailfront.html mailrules.html \
		mailrules2.html pop3front.html qmail-backend.html \
		qmail-validate.html smtpfront.html
}

pkg_config() {
	cd /var/qmail/supervise/qmail-smtpd/
	cp run run.qmail-smtpd.`date +%Y%m%d%H%M%S` && cp run.mailfront run
	cd /var/qmail/supervise/qmail-pop3d/
	cp run run.qmail-pop3d.`date +%Y%m%d%H%M%S` && cp run.mailfront run
}

pkg_postinst() {
	echo
	elog "Run emerge --config =${CATEGORY}/${PF}"
	elog "to update you run files (backup are created) in"
	elog "		/var/qmail/supervise/qmail-pop3d and"
	elog "		/var/qmail/supervise/qmail-smtpd"
	echo
}
