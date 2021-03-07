# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot systemd

EGO_PN="github.com/prometheus/node_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT="3db7773"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.12
	>=dev-util/promu-0.3.0"

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
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}"/go-cache promu build -v --prefix node_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	systemd_dounit examples/systemd/node_exporter.service
	insinto /etc/sysconfig/node_exporter
	doins examples/systemd/sysconfig.node_exporter
	popd || die
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
