# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Delayed delivery notification for qmail"
SRC_URI="http://untroubled.org/qmail-notify/archive/${P}.tar.gz"
HOMEPAGE="http://untroubled.org/qmail-notify/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/cron
	virtual/qmail
"

src_prepare() {
	eapply_user

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die 'Patching conf-cc failed.'
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die 'Patching conf-ld failed.'
	sed -e "#'ar #'$(tc-getAR) #" -e "s#'ranlib #'$(tc-getRANLIB) #" -i Makefile || die 'Patching Makefile failed.'
}

src_install () {
	exeinto /usr/sbin
	doexe qmail-notify

	exeinto /etc/cron.hourly
	doexe "${FILESDIR}"/qmail-notify.cron

	dodoc README ANNOUNCEMENT cron.hourly NEWS
}

pkg_postinst() {
	elog
	elog "Edit qmail-notify.cron in /etc/cron.hourly"
	elog "to activate qmail-notify!"
	elog
}
