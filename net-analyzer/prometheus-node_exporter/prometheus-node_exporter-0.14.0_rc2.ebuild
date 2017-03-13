# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/node_exporter/..."
EGIT_COMMIT="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT="0e60bb8"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/prometheus"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup prometheus-exporter
	enewuser prometheus-exporter -1 -1 -1 prometheus-exporter
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" src/${EGO_PN%/*}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN%/*} || die
	mkdir bin
	GOPATH="${S}" promu build -v --prefix prometheus-node_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin prometheus-node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die
	keepdir /etc/prometheus-exporter /var/log/prometheus-exporter
	fowners prometheus-exporter:prometheus-exporter /etc/prometheus-exporter /var/log/prometheus-exporter
	newinitd "${FILESDIR}"/prometheus-node_exporter.initd prometheus-node_exporter
	newconfd "${FILESDIR}"/prometheus-node_exporter.confd prometheus-node_exporter
}
