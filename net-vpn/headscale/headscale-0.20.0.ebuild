# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
DEPS_URIS=( https://github.com/slchris/gentoo-go-deps/releases/download/headscale-0.20.0/${P}-deps.tar.xz )
SRC_URI="https://github.com/juanfont/headscale/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${DEPS_URIS}"

LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="
	acct-group/headscale
	acct-user/headscale
"
RDEPEND="
	${DEPEND}
	net-firewall/iptables
"

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	go build -o ./bin/${PN} ./cmd/${PN} || die
}

src_install() {
	dobin bin/headscale
	dodoc -r config-example.yaml derp-example.yaml
	keepdir /etc/headscale /var/lib/headscale
	systemd_dounit "${FILESDIR}"/headscale.service
	newconfd "${FILESDIR}"/headscale.confd headscale
	newinitd "${FILESDIR}"/headscale.initd headscale
	fowners -R ${PN}:${PN} /etc/headscale /var/lib/headscale
}

pkg_postinst() {
	[[ -f "${EROOT}"/etc/headscale/config.yaml ]] && return
	elog "Please create ${EROOT}/etc/headscale/config.yaml before starting the service"
	elog "An example is in ${EROOT}/usr/share/doc/${P}/config-example.yaml.bz2"
	ewarn ">=headscale-0.19.0 has a DB structs breaking, please BACKUP your database before upgrading!"
	ewarn "see also: https://github.com/juanfont/headscale/pull/1171 and https://github.com/juanfont/headscale/pull/1144"
}
