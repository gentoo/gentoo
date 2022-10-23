# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
MY_PV="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT=7da1321761b3b8dfc9e496e1a60e6a476fec6018

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="https://github.com/prometheus/node_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

COMMON_DEPEND="acct-group/node_exporter
	acct-user/node_exporter"
DEPEND=">=dev-util/promu-0.3.0
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" .promu.yml || die
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" .promu-cgo.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix node_exporter || die
}

src_install() {
	dosbin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	systemd_newunit "${FILESDIR}"/node_exporter.service-1 node_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd-1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
}
