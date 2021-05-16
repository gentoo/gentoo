# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd
GIT_COMMIT=149b150fb2d87766b8462346d68b72831f622047

DESCRIPTION="A simple and flexible workload orchestrator"
HOMEPAGE="https://nomadproject.io"
SRC_URI="https://github.com/hashicorp/nomad/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nvidia"

RESTRICT+=" test"

src_compile() {
	local go_ldflags go_tags
	go_ldflags="-X github.com/hashicorp/nomad/version.GitCommit=${GIT_COMMIT}"
	go_tags="codegen_generated $(usex nvidia '' 'nonvidia')"
	CGO_ENABLED=1 \
		go build \
		-ldflags "${go_ldflags}" \
		-mod=vendor \
		-tags "${go_tags}" \
		-trimpath \
		-o bin/${PN} || die "compile failed"
}

src_install() {
	dobin bin/${PN}
	systemd_dounit dist/systemd/nomad.service
	insinto /etc/nomad.d
	newins dist/client.hcl client.hcl.example
	newins dist/server.hcl server.hcl.example
	einstalldocs
	dodoc CHANGELOG.md
	keepdir /var/lib/nomad /var/log/nomad
	newconfd "${FILESDIR}/nomad.confd" nomad
	newinitd "${FILESDIR}/nomad.initd" nomad
	insinto /etc/logrotate.d
	newins "${FILESDIR}/nomad.logrotated" nomad
}
