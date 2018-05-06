# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot systemd

EGO_PN="github.com/prometheus/pushgateway"
EGIT_COMMIT="v${PV/_rc/-rc.}"
pushgateway_COMMIT="6ceb4a1"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus push acceptor for ephemeral and batch jobs"
HOMEPAGE="https://github.com/prometheus/pushgateway"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${pushgateway_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix pushgateway || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin pushgateway/pushgateway
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die
	keepdir /var/lib/${PN} /var/log/${PN}
	fowners ${PN}:${PN} /var/lib/${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
