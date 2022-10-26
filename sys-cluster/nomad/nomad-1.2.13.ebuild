# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd
GIT_COMMIT=6892b138959f03d2fcc02975b61c24c297b360bb

DESCRIPTION="A simple and flexible workload orchestrator"
HOMEPAGE="https://nomadproject.io"
SRC_URI="https://github.com/hashicorp/nomad/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="ui"

RESTRICT=" test"

src_compile() {
	local go_ldflags go_tags
	go_ldflags="-X github.com/hashicorp/nomad/version.GitCommit=${GIT_COMMIT}"
	go_tags="codegen_generated"
	go_tags+="$(usex ui ',ui' '' )"
	CGO_ENABLED=1 \
		ego build \
		-ldflags "${go_ldflags}" \
		-tags "${go_tags}" \
		-trimpath \
		-o bin/${PN}
}

src_install() {
	dobin bin/${PN}
	systemd_dounit "${FILESDIR}"/nomad.service
	keepdir /etc/nomad.d
	einstalldocs
	dodoc CHANGELOG.md
	keepdir /var/lib/nomad /var/log/nomad
	newconfd "${FILESDIR}/nomad.confd" nomad
	newinitd "${FILESDIR}/nomad.initd" nomad
	insinto /etc/logrotate.d
	newins "${FILESDIR}/nomad.logrotated" nomad
}
