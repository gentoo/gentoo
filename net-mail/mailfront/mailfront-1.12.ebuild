# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs multilib

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="http://untroubled.org/mailfront/"
SRC_URI="http://untroubled.org/mailfront/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.106
	>=net-libs/cvm-0.81"

RDEPEND="${DEPEND}
	virtual/qmail
	net-libs/cvm"

src_configure() {
	echo "/usr/include/bglibs/" > conf-bgincs
	echo "/usr/$(get_libdir)/bglibs/" > conf-bglibs
	echo "/var/qmail" > conf-qmail
	echo "/var/qmail/bin" > conf-bin
	echo "/usr/$(get_libdir)/mailfront" > conf-modules
	echo "/usr/include/mailfront" > conf-include
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${CFLAGS} -fPIC -shared" > conf-ccso
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	#dodir /var/qmail/bin
	emake install install_prefix="${D}" || die "install failed"
	exeinto /var/qmail/supervise/qmail-smtpd
	newexe "${FILESDIR}"/run-smtpfront run.mailfront
	exeinto /var/qmail/supervise/qmail-pop3d
	newexe "${FILESDIR}"/run-pop3front run.mailfront

	dodoc ANNOUNCEMENT ChangeLog NEWS README VERSION
	dohtml *.html
}

pkg_config() {
	cd "${ROOT}"/var/qmail/supervise/qmail-smtpd/
	cp run run.qmail-smtpd.`date +%Y%m%d%H%M%S` && cp run.mailfront run
	cd "${ROOT}"/var/qmail/supervise/qmail-pop3d/
	cp run run.qmail-pop3d.`date +%Y%m%d%H%M%S` && cp run.mailfront run
}

pkg_postinst() {
	echo
	elog "Run"
	elog "emerge --config =${CATEGORY}/${PF}"
	elog "to update your run files (backups are created) in"
	elog "		/var/qmail/supervise/qmail-pop3d and"
	elog "		/var/qmail/supervise/qmail-smtpd"
	echo
}
