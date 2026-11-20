# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

# update these on every bump
COMMIT=d4c93727273331772cc6aa6ee843c5c5a7e9f7e9

DESCRIPTION="Remote IPMI exporter for Prometheus"
HOMEPAGE="https://github.com/prometheus-community/ipmi_exporter"
SRC_URI="https://github.com/prometheus-community/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="sys-libs/freeipmi"

DOCS=(
	README.md CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md SECURITY.md
	docs/metrics.md docs/configuration.md
	ipmi_local.yml ipmi_remote.yml
)

src_compile() {
	local -x CGO_ENABLED=0
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -ldflags "${go_ldflags[*]}" -o bin/${PN} .
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
