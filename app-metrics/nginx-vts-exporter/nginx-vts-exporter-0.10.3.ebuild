# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/hnlq715/nginx-vts-exporter"
EXPORTER_COMMIT="8aa2881c7050d9b28f2312d7ce99d93458611d04"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Nginx virtual host traffic stats exporter for Prometheus"
HOMEPAGE="https://github.com/hnlq715/nginx-vts-exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT Apache-2.0 BSD"
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
	dobin bin/${PN}
	dodoc README.md
	popd || die
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
