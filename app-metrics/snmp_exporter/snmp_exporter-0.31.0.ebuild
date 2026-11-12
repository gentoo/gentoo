# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver go-module systemd

# update this on every bump
SNMP_EXPORTER_COMMIT=181b59e7748732516e761b27c308794f2470d4bc

DESCRIPTION="Prometheus exporter for snmp metrics"
HOMEPAGE="https://github.com/prometheus/snmp_exporter"
SRC_URI="https://github.com/prometheus/${PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/snmp_exporter
	acct-user/snmp_exporter
	net-analyzer/net-snmp:=
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${SNMP_EXPORTER_COMMIT}
		-X github.com/prometheus/common/version.Branch=HEAD
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%Y%m%d-%T)"
	)
	ego build -ldflags "${go_ldflags[*]}" -o bin/ . ./generator
}

src_test() {
	ego test ./...
}

src_install() {
	dobin bin/${PN}
	newbin bin/generator ${PN}-generator
	dodoc {README,CONTRIBUTING}.md generator/{FORMAT,README}.md generator/generator.yml CHANGELOG.md
	insinto /etc/snmp_exporter
	doins snmp.yml
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	keepdir /var/lib/snmp_exporter /var/log/snmp_exporter
	fowners ${PN}:${PN} /var/lib/snmp_exporter /var/log/snmp_exporter
}

pkg_postinst() {
	if ver_replacing -lt 0.31.0; then
		elog "The SNMP config generator is installed as ${PN}-generator"
		elog "(previously /usr/bin/generator)."
	fi
}
