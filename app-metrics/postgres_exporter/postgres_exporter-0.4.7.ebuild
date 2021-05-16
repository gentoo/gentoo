# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/wrouesnel/postgres_exporter"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="PostgreSQL stats exporter for Prometheus"
HOMEPAGE="https://github.com/wrouesnel/postgres_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src/${EGO_PN} || die
	VERSION_SHORT="${PV}" VERSION="${PV}" GOPATH="${S}" go run mage.go binary || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin ${PN}
	dodoc README.md queries.yaml
	popd || die
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
