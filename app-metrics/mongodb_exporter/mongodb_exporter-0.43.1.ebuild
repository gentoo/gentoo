# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

# update these on every bump
BRANCH='tags/v0.43.1^0'
COMMIT=2b2cccca21104c2a00cb53bd0d785b3d656fe803

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://github.com/percona/mongodb_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-metrics/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 AGPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests require docker compose
RESTRICT="test"

DEPEND="
	acct-group/mongodb_exporter
	acct-user/mongodb_exporter
"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		COMPONENT_BRANCH=${BRANCH} \
		COMPONENT_VERSION=${PV} \
		PMM_RELEASE_FULLCOMMIT=${COMMIT} \
		build
}

src_install() {
	dobin ${PN}
	dodoc CHANGELOG {CONTRIBUTING,README,REFERENCE}.md

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit .scripts/systemd/${PN}.service

	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
}
