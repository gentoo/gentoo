# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Rabbitmq exporter for Prometheus"
HOMEPAGE="https://github.com/kbudde/rabbitmq_exporter"
SRC_URI="https://github.com/kbudde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+="	https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/rabbitmq_exporter
	acct-user/rabbitmq_exporter"
	RDEPEND="${DEPEND}"

RESTRICT+=" test "

src_compile() {
	ego build .
}

src_install() {
	dobin ${PN}
	dodoc *.md
	insinto /usr/share/${PN}
	doins *.json
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
