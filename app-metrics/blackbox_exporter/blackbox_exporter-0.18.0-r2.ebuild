# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps go-module systemd
GIT_COMMIT=1bc7680
MY_PV="v${PV/_rc/-rc.}"

DESCRIPTION="Prometheus exporter for blackbox probing via HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://github.com/prometheus/blackbox_exporter"
SRC_URI="https://github.com/prometheus/blackbox_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-util/promu"

DEPEND="
	acct-group/blackbox_exporter
	acct-user/blackbox_exporter"

FILECAPS=(
	cap_net_raw usr/bin/blackbox_exporter
)

# tests require the network
RESTRICT+=" test "

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/Head/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		-e "s/{{.Revision}}/${PV}/" .promu.yml || die
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CONFIGURATION}.md blackbox.yml
	insinto /etc/blackbox_exporter
	newins example.yml blackbox.yml
	keepdir /var/lib/blackbox_exporter /var/log/blackbox_exporter
	fowners ${PN}:${PN} /var/lib/blackbox_exporter /var/log/blackbox_exporter
	systemd_dounit "${FILESDIR}"/blackbox_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
