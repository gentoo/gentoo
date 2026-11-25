# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module edo systemd

GIT_COMMIT=333363aeb548b66340a61a7fb2b3f0e8a8d39f90

DESCRIPTION="PostgreSQL stats exporter for Prometheus"
HOMEPAGE="https://github.com/prometheus-community/postgres_exporter"
SRC_URI="https://github.com/prometheus-community/postgres_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

DEPEND="
	acct-group/postgres_exporter
	acct-user/postgres_exporter
"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/HEAD/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		.promu.yml || die "sed failed"
}

src_compile() {
	edo promu build -v --prefix bin
}

src_install() {
	dobin bin/*
	dodoc README.md queries.yaml

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
