# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95.0"
VOPONO_GUI_VER="0.1.1"

inherit cargo desktop optfeature systemd

DESCRIPTION="Launch applications via VPN tunnels using temporary network namespaces"
HOMEPAGE="https://github.com/jamesmcm/vopono"
SRC_URI="https://github.com/jamesmcm/vopono/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/vopono/releases/download/${PV}/${P}-crates.tar.xz"
SRC_URI+=" gui? ( https://dev.gentoo.org/~juippis/distfiles/vopono-gui-${VOPONO_GUI_VER}-crates.tar.xz )"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gui"

# VPN backends sorted by preference.
RDEPEND="|| (
		net-vpn/openvpn
		net-vpn/wireguard-tools
		net-vpn/openfortivpn
	)
	app-arch/xz-utils
	gui? (
		dev-libs/glib:2
		virtual/udev
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
		x11-misc/xdotool:=
	)"

src_compile() {
	cargo_src_compile
	use gui && cargo_src_compile --manifest-path vopono-gui/Cargo.toml
}

src_install() {
	cargo_src_install
	einstalldocs
	dodoc USERGUIDE.md
	systemd_dounit "${FILESDIR}"/vopono-daemon.service

	if use gui ; then
		dobin "${S}"/vopono-gui/target/release/vopono-gui
		domenu "${S}"/vopono-gui/vopono-gui.desktop
		newicon "${S}"/vopono-gui/logos/badge.png vopono-gui.png
	fi
}

pkg_postinst() {
	optfeature "using vopono without daemon mode" app-admin/sudo
}
