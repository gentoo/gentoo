# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/consul_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
CONSUL_EXPORTER_COMMIT=75f02d8

DESCRIPTION="Prometheus exporter for consul metrics"
HOMEPAGE="https://github.com/prometheus/consul_exporter"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.11
	dev-util/promu"

RESTRICT="strip test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${CONSUL_EXPORTER_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" \
		-e "s/-tags netgo/-mod vendor -tags netgo/" \
		src/${EGO_PN}/.promu.yml || die "Sed failed"
}

src_compile() {
	pushd src/${EGO_PN} || die
	GO111MODULE=on GOCACHE="${T}/go-cache" promu build -v || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin consul_exporter
	dodoc {README,CONTRIBUTING}.md
	popd || die
	keepdir /var/log/consul_exporter
	fowners ${PN}:${PN} /var/log/consul_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
