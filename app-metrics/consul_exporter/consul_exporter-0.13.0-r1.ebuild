# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

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

RESTRICT+=" test"

src_compile() {
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${CONSUL_EXPORTER_COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -ldflags "${go_ldflags[*]}" -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	dodoc {README,CONTRIBUTING}.md
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	keepdir /var/log/consul_exporter
	fowners ${PN}:${PN} /var/log/consul_exporter
}
