# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info systemd tmpfiles

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
# They should be updated on every bump.
VERSION_MINOR="84"
VERSION_SHORT="1.84.2"
VERSION_LONG="1.84.2-t5f702f4c2"
VERSION_GIT_HASH="5f702f4c2babf95e4244ce0dafbb7a50b52c1fc8"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://cdn.gmem.ca/gentoo/${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CONFIG_CHECK="~TUN"

RDEPEND="|| ( net-firewall/iptables net-firewall/nftables )"
BDEPEND=">=dev-lang/go-1.24"

RESTRICT="test"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	ego build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}
		-X tailscale.com/version.gitCommitStamp=${VERSION_GIT_HASH}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	systemd_dounit cmd/tailscaled/tailscaled.service
	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
