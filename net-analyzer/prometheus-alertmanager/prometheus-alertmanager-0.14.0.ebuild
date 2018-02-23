# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/alertmanager"
EGIT_COMMIT="v${PV/_rc/-rc.}"
ALERTMANAGER_COMMIT="fb713f6"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${ALERTMANAGER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix alertmanager || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin alertmanager/alertmanager
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	insinto /etc/alertmanager/
	newins doc/examples/simple.yml config.yml.example
	popd || die
	keepdir /var/lib/alertmanager /var/log/alertmanager
	fowners ${PN}:${PN} /var/lib/alertmanager /var/log/alertmanager
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
