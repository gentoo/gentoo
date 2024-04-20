# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus Exporter for Postfix"
HOMEPAGE="https://github.com/kumina/postfix_exporter"
SRC_URI="
	https://github.com/kumina/postfix_exporter/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~arthurzam/distfiles/app-metrics/${PN}/${P}-deps.tar.xz
"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"
RESTRICT+=" test"

RDEPEND="
	acct-group/postfix_exporter
	acct-user/postfix_exporter
"
DEPEND="${RDEPEND}
	systemd? ( sys-apps/systemd )
"

src_compile() {
	ego build -tags "$(usex systemd '' 'nosystemd')" -v -o bin/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc {CHANGELOG,README}.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
