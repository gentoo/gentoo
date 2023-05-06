# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="A Continuous Delivery platform built on Docker, written in Go"
HOMEPAGE="https://github.com/harness/drone"
SRC_URI="https://github.com/harness/drone/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/drone
	acct-user/drone"
	RDEPEND="${DEPEND}"

RESTRICT="test"

src_compile() {
	ego build -ldflags "-extldflags \"-static\"" \
		-o drone-server ./cmd/drone-server
}

src_install() {
	dobin drone-server
	dodoc CHANGELOG.md HISTORY.md
	newinitd "${FILESDIR}"/drone-server.initd drone-server
	newconfd "${FILESDIR}"/drone-server.confd drone-server

	systemd_dounit "${FILESDIR}"/drone-server.service

	keepdir /var/log/drone /var/lib/drone
	fowners -R ${PN}:${PN} /var/log/drone /var/lib/drone
}
