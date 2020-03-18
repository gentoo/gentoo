# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/justwatchcom/elasticsearch_exporter"
EXPORTER_COMMIT="92dcbf3"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Elasticsearch stats exporter for Prometheus"
HOMEPAGE="https://github.com/justwatchcom/elasticsearch_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "/-s$/d" -e "s/{{.Revision}}/${EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/elasticsearch_exporter
	dodoc {README,CHANGELOG}.md
	popd || die
	keepdir /var/log/elasticsearch_exporter
	fowners ${PN}:${PN} /var/log/elasticsearch_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
