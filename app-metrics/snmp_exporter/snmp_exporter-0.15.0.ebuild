# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/snmp_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
SNMP_EXPORTER_COMMIT="92a3da4"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for snmp metrics"
HOMEPAGE="https://github.com/prometheus/snmp_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.11
	dev-util/promu
	net-analyzer/net-snmp"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${SNMP_EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}"/go-cache promu build -v || die
	pushd generator || die
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}"/go-cache go build -mod=vendor -o ../bin/generator . || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/generator snmp_exporter
	dodoc {README,CONTRIBUTING}.md generator/{FORMAT,README}.md generator/generator.yml
	insinto /etc/snmp_exporter
	newins snmp.yml snmp.yml.example
	popd || die
	keepdir /var/lib/snmp_exporter /var/log/snmp_exporter
	fowners ${PN}:${PN} /var/lib/snmp_exporter /var/log/snmp_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
