# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

# update these on every bump
COMMIT=d0d33e679dcc7f30bafe6d6d23cf84a4fc1cd6d2

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://github.com/percona/mongodb_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="kerberos"

# tests require docker compose
RESTRICT="test"

DEPEND="
	acct-group/mongodb_exporter
	acct-user/mongodb_exporter
	kerberos? ( app-crypt/mit-krb5 )
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.25.8"

QA_PRESTRIPPED=usr/bin/mongodb_exporter

src_compile() {
	local -x CGO_ENABLED=1
	local go_ldflags=(
		-s -w
		-X main.version=${PV}
		-X main.buildDate="$(date +%FT%T%z)"
		-X main.commit=${COMMIT}
		-X main.Branch="tags/v${PV}^0"
		-X main.GoVersion=$(ego version | cut -d " " -f3)
	)
	use kerberos && local go_tags=( -tags gssapi )
	ego build "${go_tags[@]}" -ldflags "${go_ldflags[*]}" -o bin/${PN} .
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGELOG {CONTRIBUTING,README,REFERENCE}.md

	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit .scripts/systemd/${PN}.service

	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
}
