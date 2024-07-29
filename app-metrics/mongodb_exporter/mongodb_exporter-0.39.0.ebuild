# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

# update these on every bump
BRANCH='tags/v0.39.0^0'
COMMIT=430098a28613273e386563a84c57b9e84dc1a298

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://github.com/percona/mongodb_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 AGPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/mongodb_exporter
	acct-user/mongodb_exporter"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

	# tests require docker compose
	RESTRICT="test"

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
	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
}
