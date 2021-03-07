# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGO_PN="github.com/hnlq715/nginx-vts-exporter"
EXPORTER_COMMIT=b935b793fbd8478d3feea529b036e753169ddabd

DESCRIPTION="Nginx virtual host traffic stats exporter for Prometheus"
HOMEPAGE="https://github.com/hnlq715/nginx-vts-exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/promu"
COMMON_DEPEND="acct-group/nginx-vts-exporter
	acct-user/nginx-vts-exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "/-s$/d" \
		-e "s/{{.Revision}}/${EXPORTER_COMMIT}/" \
		.promu.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix bin || die
}

src_install() {
	newbin bin/${P} ${PN}
	dodoc README.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
