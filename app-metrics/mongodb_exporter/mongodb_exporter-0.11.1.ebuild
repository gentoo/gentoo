# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
COMMIT=f5e8ebea31d6fa128ae3a2fb1b747fdf4b782b2b
BRANCH=0.11.0

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://github.com/percona/mongodb_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 AGPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/mongodb_exporter
	acct-user/mongodb_exporter"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

src_compile() {
	GOFLAGS="${GOFLAGS} -mod=vendor" emake \
		TRAVIS_TAG="${PV}" \
		APP_REVISION=${COMMIT} \
		TRAVIS_BRANCH=${BRANCH} \
		build
}

src_install() {
	dobin bin/${PN}
	dodoc {README,CHANGELOG}.md
	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
