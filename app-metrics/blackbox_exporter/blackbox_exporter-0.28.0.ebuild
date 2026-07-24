# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit fcaps go-module systemd
MY_PV="v${PV/_rc/-rc.}"

DESCRIPTION="Prometheus exporter for blackbox probing via HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://github.com/prometheus/blackbox_exporter"

SRC_URI="https://github.com/prometheus/blackbox_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/blackbox_exporter/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/blackbox_exporter
	acct-user/blackbox_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	>=dev-lang/go-1.25.0
	dev-util/promu
"

FILECAPS=(
	cap_net_raw usr/bin/blackbox_exporter
)

# tests require the network
RESTRICT+=" test "

PATCHES=( "${FILESDIR}/0.28.0-promu-config.patch" )

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} ${PN}
	dodoc {README,CHANGELOG,CONFIGURATION}.md blackbox.yml
	insinto /etc/blackbox_exporter
	newins example.yml blackbox.yml
	keepdir /var/lib/blackbox_exporter /var/log/blackbox_exporter
	systemd_dounit "${FILESDIR}"/blackbox_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	fowners ${PN}:${PN} /var/lib/blackbox_exporter /var/log/blackbox_exporter
}
