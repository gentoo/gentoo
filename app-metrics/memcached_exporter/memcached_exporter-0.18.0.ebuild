# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT=6df2a9958afbc76f81ec74e8b3551a849449812d

DESCRIPTION="Prometheus exporter for memcached"
HOMEPAGE="https://github.com/prometheus/memcached_exporter"
SRC_URI="https://github.com/prometheus/memcached_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
# tests require the memcached_exporter daemon to be running locally
RESTRICT+=" test "

DEPEND="
	acct-group/memcached_exporter
	acct-user/memcached_exporter
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${GIT_COMMIT}
		-X github.com/prometheus/common/version.Branch=HEAD
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%Y%m%d-%T)"
	)
	ego build -ldflags "${go_ldflags[*]}" -o bin/${PN} ./cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc *.md
	systemd_dounit "${FILESDIR}"/${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}
