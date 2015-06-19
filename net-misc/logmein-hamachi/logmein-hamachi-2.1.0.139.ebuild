# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/logmein-hamachi/logmein-hamachi-2.1.0.139.ebuild,v 1.1 2015/03/28 11:18:21 dlan Exp $

EAPI=5
inherit eutils linux-info systemd

DESCRIPTION="LogMeIn Hamachi VPN tunneling engine"
HOMEPAGE="https://secure.logmein.com/products/hamachi"
SRC_URI="x86?	( https://secure.logmein.com/labs/${P}-x86.tgz )
	amd64?	( https://secure.logmein.com/labs/${P}-x64.tgz )"

LICENSE="LogMeIn"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="!net-misc/hamachi"

RESTRICT="mirror"

QA_PREBUILT="/opt/${PN}/bin/hamachid"
QA_PRESTRIPPED="/opt/${PN}/bin/hamachid"
QA_WX_LOAD="/opt/${PN}/bin/hamachid"

pkg_setup() {
	einfo "Checking your kernel configuration for TUN/TAP support."
	CONFIG_CHECK="~TUN"
	check_extra_config
}

src_unpack() {
	unpack ${A}
	mv "${P}-$(use x86 && echo x86 || echo x64)" "${S}" || die
}

src_install() {
	into /opt/${PN}
	dobin hamachid dnsup dnsdown
	dosym /opt/${PN}/bin/hamachid /usr/bin/hamachi

	# Config and log directory
	dodir /var/lib/${PN}

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	dodoc CHANGES README
}

pkg_postinst() {
	elog "LogMeIn Hamachi2 is installed."
	elog "Consult the README file on how to configure your client."
	elog "You can run the client 'hamachi' as root,"
	elog "or as a user if you add a newline terminated line:"
	elog "Ipc.User      <login name>"
	elog "to the file '/var/lib/${PN}/h2-engine-override.cfg'"
	elog "and restart the daemon with"
	elog "/etc/init.d/${PN} restart"
	elog "or:"
	elog "systemctl restart ${PN}"
	elog "To enable auto-login when the service starts set a nickname in"
	elog "/etc/conf.d/${PN} (only supported using openRC)"
}
