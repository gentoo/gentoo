# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="ClamSMTP is an SMTP filter that allows you to check for viruses using the ClamAV anti-virus software"
HOMEPAGE="http://memberwebs.com/nielsen/software/clamsmtp/"

SRC_URI="http://memberwebs.com/nielsen/software/clamsmtp/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ~sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND=">=app-antivirus/clamav-0.75"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README NEWS
	newinitd "${FILESDIR}"/clamsmtpd.init clamsmtpd
	insinto /etc
	newins doc/clamsmtpd.conf clamsmtpd.conf

	sed -i \
		-e "s|\#\(ClamAddress\): .*|\1: /var/run/clamav/clamd.sock|" \
		-e "s|\#\(User\): .*|\1: clamav|" \
		"${D}"/etc/clamsmtpd.conf
}

pkg_postinst() {
	echo
	elog "For help configuring Postfix to use clamsmtpd, see:"
	elog "    http://memberwebs.com/nielsen/software/clamsmtp/postfix.html"
	echo
	ewarn "You'll need to have ScanMail support turned on in clamav.conf"
	ewarn "Also, make sure the clamd scanning daemon is running (not just freshclam)"
	echo
}
