# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

DESCRIPTION="Prometheus exporter for exabgp"
HOMEPAGE="https://github.com/lusis/exabgp_exporter"
EGIT_COMMIT="6fe8ef056a87881c8d7568cba83b3c18f7165d3a"
SRC_URI="https://github.com/lusis/exabgp_exporter/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_compile() {
	CGO_ENABLED=0 go build \
		-ldflags "-X github.com/prometheus/common/version.Version=${PV%_*}
			-X github.com/prometheus/common/version.Revision=${EGIT_COMMIT} \
			-X github.com/prometheus/common/version.Branch=master \
			-X github.com/prometheus/common/version.BuildUser=$(whoami)
			-X github.com/prometheus/common/version.BuildDate=$(date -u +'%FT%T%z')" \
		-o ./bin/${PN} ./cmd/exabgp_exporter/main.go || die
}

src_install() {
	dobin ./bin/${PN}
	dodoc README.md
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
