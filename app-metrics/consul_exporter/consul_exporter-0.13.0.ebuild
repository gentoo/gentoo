# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

CONSUL_EXPORTER_COMMIT=11bf27e69d

MY_PV="v${PV/_rc/-rc.}"

DESCRIPTION="Prometheus exporter for consul metrics"
HOMEPAGE="https://github.com/prometheus/consul_exporter"
SRC_URI="https://github.com/prometheus/consul_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/consul_exporter
	acct-user/consul_exporter"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="dev-util/promu"

RESTRICT+=" test"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Revision}}/${CONSUL_EXPORTER_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" \
		.promu.yml || die "Sed failed"
}

src_compile() {
	promu build -v || die
}

src_install() {
	dobin ${PN}
	dodoc {README,CONTRIBUTING}.md
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/consul_exporter
	fowners ${PN}:${PN} /var/log/consul_exporter
}
