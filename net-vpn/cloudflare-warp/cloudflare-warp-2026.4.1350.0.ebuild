# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker systemd xdg desktop

DESCRIPTION="Cloudflare Warp Client"
HOMEPAGE="https://1.1.1.1"
SRC_URI="https://pkg.cloudflareclient.com/pool/jammy/main/c/cloudflare-warp/${PN}_${PV}_amd64.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+gui"
RESTRICT="bindist mirror"

DEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	net-firewall/nftables
	net-libs/libpcap
	sys-apps/dbus
	gui? (
		app-accessibility/at-spi2-core:2
		dev-libs/ayatana-ido
		dev-libs/libayatana-appindicator
		dev-libs/libayatana-indicator:3
		dev-libs/libdbusmenu
		media-libs/fontconfig
		media-libs/harfbuzz
		media-libs/libepoxy
		net-libs/libsoup:3.0
		net-libs/webkit-gtk:4.1
		net-misc/curl
		virtual/zlib
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/pango
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-admin/chrpath
	dev-util/patchelf
"

QA_PREBUILT="
	usr/bin/warp-.*
	usr/libexec/warp/.*
"

src_prepare() {
	default
	# Fixup the library dependencies to match the ones in the system
	patchelf --replace-needed libpcap.so.0.8 libpcap.so.1 "${S}"/bin/warp-dex || die
	chrpath -d "${S}/usr/lib/warp/lib/crashpad_handler" || die
	rm "${S}/usr/lib/warp/lib/libdartjni.so" || die
}

src_install() {
	dobin bin/warp-{cli,dex,diag,svc}
	domenu usr/share/applications/com.cloudflare.warp.desktop
	systemd_dounit lib/systemd/system/warp-svc.service
	newinitd "${FILESDIR}"/warp-svc.initd warp-svc

	if use gui; then
		mkdir -p "${D}"/usr/libexec/warp || die
		cp -r "${S}"/usr/lib/warp/* "${D}"/usr/libexec/warp/ || die

		dosym ../libexec/warp/warp-taskbar usr/bin/warp-taskbar
		systemd_douserunit usr/lib/systemd/user/warp-taskbar.service
		domenu usr/share/applications/com.cloudflare.WarpTaskbar.desktop

		doicon -s scalable usr/share/icons/hicolor/scalable/apps/*.svg

		insinto /usr/share/dbus-1/services
		doins usr/share/dbus-1/services/com.cloudflare.WarpTaskbar.service
	fi
}
