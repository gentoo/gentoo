# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd xdg desktop

DESCRIPTION="Cloudflare Warp Client"
HOMEPAGE="https://1.1.1.1"
SRC_URI="
	https://downloads.cloudflareclient.com/v1/download/fedora35-intel/version/${PV}
		-> ${P}.x86_64.rpm
"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+gui"
RESTRICT="bindist mirror"

DEPEND="
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	net-firewall/nftables
	net-libs/libpcap
	sys-apps/dbus
	x11-libs/cairo
	gui? (
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
	)
"
RDEPEND="${DEPEND}"

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	dobin bin/warp-{cli,dex,diag,svc}
	systemd_dounit opt/cloudflare-warp/warp-svc.service

	if use gui; then
		dobin bin/{warp-desktop-svc,warp-taskbar}
		systemd_douserunit usr/lib/systemd/user/warp-desktop-svc.service
		domenu usr/share/applications/com.cloudflare.WarpTaskbar.desktop

		doicon -s scalable usr/share/icons/hicolor/scalable/apps/*.svg
		insinto /usr/share/warp/images
		doins usr/share/warp/images/*.png

		insinto /etc/xdg/autostart
		doins etc/xdg/autostart/com.cloudflare.WarpTaskbar.desktop
	fi
}
