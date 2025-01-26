# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Nginx virtual host traffic stats exporter for Prometheus"
HOMEPAGE="https://github.com/hnlq715/nginx-vts-exporter"
SRC_URI="https://github.com/hnlq715/nginx-vts-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/nginx-vts-exporter
	acct-user/nginx-vts-exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	ego build .
}

src_install() {
	dobin ${PN}
	dodoc README.md
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
