# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="Process exporter for prometheus"
HOMEPAGE="https://github.com/ncabatoff/process-exporter"
SRC_URI="https://github.com/ncabatoff/process-exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake build
}

src_install() {
	dobin ${PN}
	dodoc *.md
	insinto /etc/${PN}
	doins packaging/conf/all.yaml
	systemd_dounit packaging/${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
}
