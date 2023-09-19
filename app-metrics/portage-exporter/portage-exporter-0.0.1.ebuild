# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus exporter for Gentoo Portage"
HOMEPAGE="https://github.com/projg2/portage-exporter"
SRC_URI="
	https://github.com/projg2/${PN}/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="GPL-3 Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	ego build -o ${PN} ./cmd/portage-exporter/
}

src_install() {
	dobin ${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
