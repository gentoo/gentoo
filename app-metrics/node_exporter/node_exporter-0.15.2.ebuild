# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/node_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT="98bc649"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix node_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
