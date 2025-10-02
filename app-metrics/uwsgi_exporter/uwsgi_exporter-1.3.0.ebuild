# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT="c72402e3"
DESCRIPTION="uWSGI metrics exporter for prometheus.io"
HOMEPAGE="https://github.com/timonwong/uwsgi_exporter"
SRC_URI="
	https://github.com/timonwong/uwsgi_exporter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # no tests

RDEPEND="
	acct-group/uwsgi_exporter
	acct-user/uwsgi_exporter
"
DEPEND="${RDEPEND}"

src_compile() {
	local -x GO111MODULE=on
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${GIT_COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -tags 'netgo' -mod=vendor -ldflags "${go_ldflags[*]}" -o bin/${PN} ./cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc README.md

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
