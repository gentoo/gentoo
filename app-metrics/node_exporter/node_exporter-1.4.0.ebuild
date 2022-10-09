# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="https://github.com/prometheus/node_exporter/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~ajak/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

COMMON_DEPEND="acct-group/node_exporter
	acct-user/node_exporter"
DEPEND=">=dev-util/promu-0.3.0
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix node_exporter || die
}

src_install() {
	dosbin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	systemd_newunit "${FILESDIR}"/node_exporter-r1.service node_exporter.service
	newinitd "${FILESDIR}/${PN}-r1.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners "${PN}:${PN}" /var/lib/node_exporter /var/log/node_exporter
}
