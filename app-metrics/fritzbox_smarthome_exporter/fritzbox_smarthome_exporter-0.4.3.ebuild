# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Prometheus exporter for FRITZ!Box Smart Home"
HOMEPAGE="https://github.com/jayme-github/fritzbox_smarthome_exporter"
SRC_URI="https://github.com/jayme-github/fritzbox_smarthome_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="acct-group/fritzbox_smarthome_exporter
	acct-user/fritzbox_smarthome_exporter"

RDEPEND="${DEPEND}"

src_compile() {
	ego build -v -o bin/${PN}
}

src_test() {
	ego test -v ./...
}

src_install() {
	dobin bin/*
	einstalldocs
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	# restrict access because conf.d entry could contain
	# FRITZ!Box credentials
	fperms 0640 /etc/conf.d/${PN}
	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
