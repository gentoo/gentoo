# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

# update this on every bump
SNMP_EXPORTER_COMMIT=48b810af

DESCRIPTION="Prometheus exporter for snmp metrics"
HOMEPAGE="https://github.com/prometheus/snmp_exporter"
SRC_URI="https://github.com/prometheus/${PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/snmp_exporter
	acct-user/snmp_exporter
	net-analyzer/net-snmp"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${SNMP_EXPORTER_COMMIT}/" .promu.yml || die
}

src_compile() {
	promu build --prefix bin || die
	pushd generator || die
	ego build -o ../bin/generator
	popd || die
}

src_test() {
	emake test-flags= test
}

src_install() {
	dobin bin/generator
	newbin bin/${PN}-${PV} ${PN}
	dodoc {README,CONTRIBUTING}.md generator/{FORMAT,README}.md generator/generator.yml CHANGELOG.md
	insinto /etc/snmp_exporter
	newins snmp.yml snmp.yml.example
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	keepdir /var/lib/snmp_exporter /var/log/snmp_exporter
	fowners ${PN}:${PN} /var/lib/snmp_exporter /var/log/snmp_exporter
}
