# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
GIT_COMMIT=d7b4f0c7
MY_PV="${PV/_rc/-rc.}"

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="https://github.com/prometheus/alertmanager/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT+=" test"

BDEPEND="dev-util/promu"

DEPEND="
	acct-group/alertmanager
	acct-user/alertmanager"
	RDEPEND="${DEPEND}"

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
	newins doc/examples/simple.yml config.yml
	keepdir /var/lib/alertmanager /var/log/alertmanager
	systemd_dounit "${FILESDIR}"/alertmanager.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	fowners ${PN}:${PN} /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
}
