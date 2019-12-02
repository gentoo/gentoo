# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user golang-build golang-vcs-snapshot

EGO_PN=github.com/percona/mongodb_exporter
EXPORTER_COMMIT=a642618

DESCRIPTION="Prometheus exporter for MongoDB"
HOMEPAGE="https://github.com/percona/mongodb_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 AGPL-3 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

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
	dobin bin/mongodb_exporter
	dodoc {README,CHANGELOG}.md
	popd || die
	keepdir /var/log/mongodb_exporter
	fowners ${PN}:${PN} /var/log/mongodb_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
