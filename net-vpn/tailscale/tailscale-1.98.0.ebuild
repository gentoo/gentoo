# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info shell-completion systemd sysroot tmpfiles

# They should be updated on every bump.
VERSION_GIT_HASH="f2d5ef72bd2fc32db115550646a58076b7898853"
VERSION_MINOR=$(ver_cut 2)
VERSION_SHORT=${PV}
VERSION_LONG=${PV}-t${VERSION_GIT_HASH::9}

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="test"

CONFIG_CHECK="~TUN"

RDEPEND="|| ( net-firewall/iptables net-firewall/nftables )"
BDEPEND=">=dev-lang/go-1.26.2"

src_compile() {
	# This translates the build command from upstream's build_dist.sh to an
	# ebuild equivalent.
	local go_ldflags=(
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}
		-X tailscale.com/version.gitCommitStamp=${VERSION_GIT_HASH}
	)
	ego build -tags xversion -ldflags "${go_ldflags[*]}" -o bin/ ./cmd/tailscale ./cmd/tailscaled

	einfo "generating shell completion files"
	sysroot_try_run_prefixed ./bin/tailscale completion bash > ${PN}.bash || die
	sysroot_try_run_prefixed ./bin/tailscale completion zsh > ${PN}.zsh || die
	sysroot_try_run_prefixed ./bin/tailscale completion fish > ${PN}.fish || die
}

src_install() {
	dosbin bin/tailscaled
	dobin bin/tailscale

	systemd_dounit cmd/tailscaled/{tailscaled.service,tailscale-online.target,tailscale-wait-online.service}
	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}

	[[ -s ${PN}.bash ]] && newbashcomp ${PN}.bash ${PN}
	[[ -s ${PN}.zsh ]] && newzshcomp ${PN}.zsh _${PN}
	[[ -s ${PN}.fish ]] && dofishcomp ${PN}.fish
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
