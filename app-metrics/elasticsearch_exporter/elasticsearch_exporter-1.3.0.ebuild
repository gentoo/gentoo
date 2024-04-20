# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_COMMIT=fe20e49
MY_PV=${PV/_/}
inherit go-module
DESCRIPTION="Elasticsearch stats exporter for Prometheus"
HOMEPAGE="https://github.com/justwatchcom/elasticsearch_exporter"
SRC_URI="https://github.com/justwatchcom/elasticsearch_exporter/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/elasticsearch_exporter
	acct-user/elasticsearch_exporter"
	RDEPEND="${DEPEND}"
BDEPEND="dev-util/promu"

src_prepare() {
	default
	sed -i -e "/-s$/d" -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	promu build --prefix bin || die
}

src_test() {
	emake test-flags= test
}

src_install() {
	dobin bin/elasticsearch_exporter
	dodoc {README,CHANGELOG}.md
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/elasticsearch_exporter
	fowners ${PN}:${PN} /var/log/elasticsearch_exporter
}
