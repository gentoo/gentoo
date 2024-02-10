# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
MY_PV="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT=1b48970ffcf5630534fb00bb0687d73c66d1c959

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="https://github.com/prometheus/node_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="selinux"

COMMON_DEPEND="acct-group/node_exporter
	acct-user/node_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-node_exporter )"
BDEPEND=">=dev-util/promu-0.3.0"

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

src_test() {
	emake test-flags= test
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
