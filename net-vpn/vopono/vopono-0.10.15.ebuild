# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.88.0"

inherit cargo optfeature systemd

DESCRIPTION="Launch applications via VPN tunnels using temporary network namespaces"
HOMEPAGE="https://github.com/jamesmcm/vopono"
SRC_URI="https://github.com/jamesmcm/vopono/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/vopono/releases/download/${PV}/${P}-crates.tar.xz"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

# VPN backends sorted by preference.
RDEPEND="|| (
		net-vpn/openvpn
		net-vpn/wireguard-tools
		net-vpn/openfortivpn
	)
	app-arch/xz-utils"

src_install() {
	cargo_src_install
	einstalldocs
	dodoc USERGUIDE.md
	systemd_dounit "${FILESDIR}"/vopono-daemon.service
}

pkg_postinst() {
	optfeature "using vopono without daemon mode" app-admin/sudo
}
