# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit fcaps go-module systemd

DESCRIPTION="Fast, cross-platform HTTP/2 web server with automatic HTTPS"
HOMEPAGE="https://caddyserver.com"
SRC_URI="https://github.com/caddyserver/caddy/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD ECL-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
RDEPEND="
	acct-user/http
	acct-group/http"
DEPEND="${RDEPEND}"

RESTRICT="test"

FILECAPS=(
	-m 755 'cap_net_bind_service=+ep' usr/bin/${PN}
)

src_compile() {
	ego build ./cmd/caddy
}

src_install() {
	dobin caddy
	dodoc README.md
	keepdir /etc/caddy
	insinto /etc/caddy
	newins "${FILESDIR}"/caddy_config.json caddy_config.json.example
	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}/initd" "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" "${PN}"
}

pkg_postinst() {
	fcaps_pkg_postinst
}
