# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Prometheus exporter for apache metrics"
HOMEPAGE="https://github.com/Lusitaniae/apache_exporter"

SRC_URI="https://github.com/Lusitaniae/apache_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	acct-group/apache_exporter
	acct-user/apache_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	>=dev-lang/go-1.25.0
	dev-util/promu
"

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} ${PN}
	dodoc {README,CHANGELOG}.md
	newinitd "${FILESDIR}"/apache_exporter.initd apache_exporter
	newconfd "${FILESDIR}"/apache_exporter.confd apache_exporter

	systemd_dounit "${FILESDIR}"/apache_exporter.service
	insinto /etc/sysconfig
	newins "${FILESDIR}/sysconfig.apache_exporter" apache_exporter

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"

	keepdir /var/log/apache_exporter
	fowners -R ${PN}:${PN} /var/log/apache_exporter
}
