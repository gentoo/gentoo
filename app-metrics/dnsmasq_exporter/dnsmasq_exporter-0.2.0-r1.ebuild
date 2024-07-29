# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="prometheus exporter for dnsmasq"
HOMEPAGE="https://github.com/google/dnsmasq_exporter"
SRC_URI="https://github.com/google/dnsmasq_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/dnsmasq_exporter
	acct-user/dnsmasq_exporter"
	RDEPEND="${DEPEND}"

src_compile() {
	ego build
}

src_install() {
	dobin dnsmasq_exporter
	keepdir /var/log/dnsmasq_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	fowners ${PN}:${PN} /var/log/dnsmasq_exporter
}

pkg_postinst() {
	if [[ -e "${EROOT}"/var/log/ddnsmasq_exporter ]]; then
		elog "The log directory is now ${EROOT}/var/log/dnsmasq_exporter"
		elog "in order 	to fix a typo."
	fi
}
