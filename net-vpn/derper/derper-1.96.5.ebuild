# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info systemd

# share same source with net-vpn/tailscale
VERSION_GIT_HASH="41cb72f27119f95b859335f3ffc3434d6ca55e23"
VERSION_MINOR=$(ver_cut 2)
VERSION_SHORT=${PV}
VERSION_LONG=${PV}-t${VERSION_GIT_HASH::9}

MY_P="tailscale-${PV}"
DESCRIPTION="DERP server for tailscale network"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/tailscale/releases/download/v${PV}/${MY_P}-vendor.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CONFIG_CHECK="~TUN"

BDEPEND="
	acct-group/derper
	acct-user/derper
	>=dev-lang/go-1.26.1
"

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
	build_dist ./cmd/derper
	build_dist ./cmd/derpprobe
}

src_install() {
	dobin derper
	dobin derpprobe

	insinto /etc/default
	newins "${FILESDIR}"/derper.defaults derper
	systemd_dounit "${FILESDIR}"/derper.service
	systemd_install_serviced "${FILESDIR}"/derper.service.conf derper

	newinitd "${FILESDIR}"/derper.initd derper

	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	exeinto /usr/libexec
	doexe "${FILESDIR}"/derper-pre.sh
}
