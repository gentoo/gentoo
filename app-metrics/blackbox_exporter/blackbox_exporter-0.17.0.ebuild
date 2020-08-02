# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps go-module user

EGO_PN=github.com/prometheus/blackbox_exporter
MY_PV="v${PV/_rc/-rc.}"
GIT_COMMIT=1bc7680

DESCRIPTION="Prometheus exporter for blackbox probing via HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://github.com/prometheus/blackbox_exporter"
SRC_URI="https://github.com/prometheus/blackbox_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/promu"

FILECAPS=(
	cap_net_raw usr/bin/blackbox_exporter
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CONFIGURATION}.md blackbox.yml
	insinto /etc/blackbox_exporter
	newins example.yml blackbox.yml.example
	keepdir /var/lib/blackbox_exporter /var/log/blackbox_exporter
	fowners ${PN}:${PN} /var/lib/blackbox_exporter /var/log/blackbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
