# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info systemd

DESCRIPTION="LogMeIn Hamachi VPN tunneling engine"
HOMEPAGE="https://www.vpn.net/"
SRC_URI="x86?	( https://www.vpn.net/installers/${P}-x86.tgz )
	amd64?	( https://www.vpn.net/installers/${P}-x64.tgz )"

LICENSE="LogMeIn-2013"
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
	mv "${P}-$(usex x86 x86 x64)" "${S}" || die
}

src_install() {
	into /opt/${PN}
	dobin hamachid dnsup dnsdown
	dosym ../../opt/${PN}/bin/hamachid /usr/bin/hamachi

	# Config and log directory
	keepdir /var/lib/${PN}

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
