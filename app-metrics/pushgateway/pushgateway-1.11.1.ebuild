# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT="aff0d83"
DESCRIPTION="Prometheus push acceptor for ephemeral and batch jobs"
HOMEPAGE="https://github.com/prometheus/pushgateway"
SRC_URI="
	https://github.com/prometheus/pushgateway/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
RESTRICT="test"

RDEPEND="
	acct-group/pushgateway
	acct-user/pushgateway
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/go-1.24"

src_compile() {
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${GIT_COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -mod=vendor -ldflags "${go_ldflags[*]}" -o bin/${PN} .
}

src_install() {
	dobin bin/${PN}
	dodoc {README,CHANGELOG,CONTRIBUTING}.md

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}-2.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-1.confd ${PN}
	systemd_newunit "${FILESDIR}/${PN}-1.service" "${PN}.service"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
