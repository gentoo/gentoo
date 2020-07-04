# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fcaps user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/blackbox_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
BLACKBOX_EXPORTER_COMMIT="991f898"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for blackbox probing via HTTP, HTTPS, DNS, TCP and ICMP"
HOMEPAGE="https://github.com/prometheus/blackbox_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.12
	dev-util/promu"

FILECAPS=(
	cap_net_raw usr/bin/blackbox_exporter
)

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${BLACKBOX_EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GO111MODULE=on GOPATH="${S}" promu build -v --prefix blackbox_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin blackbox_exporter/blackbox_exporter
	dodoc {README,CONFIGURATION}.md blackbox.yml
	insinto /etc/blackbox_exporter
	newins example.yml blackbox.yml.example
	popd || die
	keepdir /var/lib/blackbox_exporter /var/log/blackbox_exporter
	fowners ${PN}:${PN} /var/lib/blackbox_exporter /var/log/blackbox_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
