# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module user
EXPORTER_COMMIT=a642618

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://github.com/percona/mongodb_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 AGPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	go build -mod=vendor . || die
}

src_install() {
	dobin ${PN}
	dodoc {README,CHANGELOG}.md
	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
