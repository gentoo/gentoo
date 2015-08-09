# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="an implementation of the checkpassword interface that checks a password"
HOMEPAGE="http://checkpw.sourceforge.net/checkpw/"
SRC_URI="mirror://sourceforge/checkpw/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
IUSE="static"

KEYWORDS="~x86 ~ppc ~sparc ~alpha ~mips ~hppa ~amd64 ~ia64"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-qa.patch"
	sed -i -e 's/head -1/head -n 1/g' Makefile auto_*.do default.do || die
}

src_compile() {
	use static && append-ldflags -static
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo ".maildir" > conf-maildir || die

	if [ -z "${QMAIL_HOME}" ]; then
		QMAIL_HOME="/var/qmail"
		ewarn "QMAIL_HOME is null! Using default."
		ewarn "Create the qmail user and set the homedir to your desired location."
	fi
	einfo "Using ${QMAIL_HOME} as qmail's default home directory."
	echo "${QMAIL_HOME}" > conf-qmail || die

	emake || die
}

src_install() {
	into /
	dobin checkpw checkapoppw selectcheckpw loginlog
	fperms 0700 /bin/checkpw /bin/checkapoppw /bin/selectcheckpw

	dodoc CHANGES README
	docinto samples
	dodoc run-{apop,both,multidir,multipw,pop,rules}
}

pkg_postinst() {
	elog
	elog "How to set password:"
	elog
	elog " % echo 'YOURPASSWORD' > ~/.maildir/.password"
	elog " % chmod 600 ~/.maildir/.password"
	elog
	elog "Replace YOURPASSWORD with your plain password."
	elog
}
