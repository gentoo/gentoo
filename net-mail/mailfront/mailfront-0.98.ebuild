# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="http://untroubled.org/mailfront/"
SRC_URI="http://untroubled.org/mailfront/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.022
	>=net-libs/cvm-0.71
	"
RDEPEND="
	${DEPEND}
	virtual/qmail
	net-libs/cvm
	"

src_compile() {
	echo "/usr/include/bglibs/" > conf-bgincs
	echo "/usr/lib/bglibs/" > conf-bglibs
	echo "/var/qmail/bin" > conf-bin
	echo "/var/qmail" > conf-qmail
	echo "${D}/var/qmail/bin" > conf-bin
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC)" > conf-ld
	emake || die
}

src_install() {
	dodir /var/qmail/bin
	emake install || die

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
