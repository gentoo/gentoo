# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
SRC_URI="
	https://github.com/juanfont/headscale/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~jsmolic/distfiles/net-vpn/headscale/${P}-deps.tar.xz
"

LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/headscale
	acct-user/headscale
"
RDEPEND="
	${DEPEND}
	net-firewall/iptables
"

src_install() {
	keepdir /var/lib/headscale
	keepdir /etc/headscale

	dobin headscale

	insinto /etc/headscale
	doins "${FILESDIR}"/config.yaml.example

	fowners -R ${PN}:${PN} /etc/headscale
	fowners -R ${PN}:${PN} /var/lib/headscale

	systemd_dounit "${FILESDIR}"/headscaled.service
	newinitd "${FILESDIR}"/headscaled.initd headscaled
	newconfd "${FILESDIR}"/headscale.conf headscaled
}

pkg_postinst() {
	elog "You will need to set up your /etc/headscale/config.yaml file before starting the service"
	elog "Please use /etc/headscale/config.yaml.example as example"
	elog "More in the official documentation https://github.com/juanfont/headscale/tree/main/docs"
}
