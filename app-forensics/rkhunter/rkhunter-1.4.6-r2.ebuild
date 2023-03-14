# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Rootkit Hunter scans for known and unknown rootkits, backdoors, and sniffers"
HOMEPAGE="http://rkhunter.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-grep-3.8.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~x86"
IUSE=""

RDEPEND="
	app-shells/bash
	dev-lang/perl
	sys-process/lsof[rpc]
"

S="${WORKDIR}/${P}/files"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.6-conf.patch"
	"${FILESDIR}/${PN}-1.4.6-no-insecure-web.patch"
	"${WORKDIR}/${PN}-1.4.6-grep-3.8.patch"
)

src_install() {
	# rkhunter requires to be root
	dosbin ${PN}

	insinto /etc
	doins ${PN}.conf

	exeinto /usr/lib/${PN}/scripts
	doexe *.pl

	insinto /var/lib/${PN}/db
	doins *.dat

	insinto /var/lib/${PN}/db/i18n
	doins i18n/*

	doman ${PN}.8
	dodoc ACKNOWLEDGMENTS CHANGELOG FAQ README

	exeinto /etc/cron.daily
	newexe "${FILESDIR}/${PN}-1.4.cron" ${PN}

	newbashcomp "${FILESDIR}/${PN}.bash-completion" ${PN}
}

pkg_postinst() {
	elog "A cron script has been installed to /etc/cron.daily/rkhunter."
	elog "To enable it, edit /etc/cron.daily/rkhunter and follow the"
	elog "directions."
	elog "If you want ${PN} to send mail, you will need to install"
	elog "virtual/mailx or alter the EMAIL_CMD variable in the"
	elog "cron script and possibly the MAIL_CMD variable in the"
	elog "${PN}.conf file to use another mail client."
}
