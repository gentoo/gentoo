# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module user
GIT_COMMIT=4c6c03eb
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="https://github.com/prometheus/alertmanager/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/promu"

RESTRICT+=" test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CHANGELOG}.md
	insinto /etc/alertmanager/
	newins doc/examples/simple.yml config.yml.example
	keepdir /var/lib/alertmanager /var/log/alertmanager
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	fowners ${PN}:${PN} /var/lib/alertmanager /var/log/alertmanager
}
