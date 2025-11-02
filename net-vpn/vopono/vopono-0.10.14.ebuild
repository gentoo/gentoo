# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo optfeature

DESCRIPTION="Launch applications via VPN tunnels using temporary network namespaces"
HOMEPAGE="https://github.com/jamesmcm/vopono"
SRC_URI="https://github.com/jamesmcm/vopono/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~juippis/distfiles/${P}-crates.tar.xz"

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
}

pkg_postinst() {
	# Judging from https://github.com/jamesmcm/vopono/issues/189 sudo is a pretty strict
	# dependency, but not _absolutely_ needed.
	# Alternatives like doas or run0 doesn't seem to be supported yet, but once they are, another
	# "|| ( )" dependency block could be added for them.
	optfeature "easy and automatic set up of network namespaces" app-admin/sudo
}
