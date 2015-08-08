# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1

DESCRIPTION="Rootkit Hunter scans for known and unknown rootkits, backdoors, and sniffers"
HOMEPAGE="http://rkhunter.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"
IUSE=""

RDEPEND="
	app-shells/bash
	dev-lang/perl
	sys-process/lsof[rpc]
	virtual/cron
	virtual/mailx
"

S="${WORKDIR}/${P}/files"

src_prepare() {
	epatch "${FILESDIR}/${P}.conf.patch"
}

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
	newexe "${FILESDIR}/${PN}-1.3.cron" ${PN}

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
