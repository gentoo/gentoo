# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
DEPS_URIS=( https://dev.gentoo.org/~{dlan,jsmolic}/distfiles/net-vpn/headscale/${P}-deps.tar.xz )
SRC_URI="https://github.com/juanfont/headscale/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${DEPS_URIS[@]}"

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

PATCHES=(
	"${FILESDIR}"/config-socket.patch
)

src_compile() {
	emake version=v${PV}
}

src_install() {
	dobin headscale
	dodoc -r docs/* config-example.yaml
	keepdir /etc/headscale /var/lib/headscale
	systemd_dounit "${FILESDIR}"/headscale.service
	newconfd "${FILESDIR}"/headscale.confd headscale
	newinitd "${FILESDIR}"/headscale.initd headscale
	fowners -R ${PN}:${PN} /etc/headscale /var/lib/headscale
}

pkg_postinst() {
	[[ -f "${EROOT}"/etc/headscale/config.yaml ]] && return
	elog "Please create ${EROOT}/etc/headscale/config.yaml before starting the service"
	elog "An example is in ${EROOT}/usr/share/doc/${PV}/config-example.yaml"
}
