# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-4)$(ver_cut 5).4"

inherit desktop xdg-utils

DESCRIPTION="A client software for quality voice communication via the internet"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="https://files.teamspeak-services.com/pre_releases/client/${MY_PV/_/-}/teamspeak-client.tar.gz -> ${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}"

LICENSE="teamspeak5 || ( GPL-2 GPL-3 LGPL-3 )"
SLOT="5"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/olm
	media-libs/alsa-lib
	media-libs/harfbuzz
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	|| (
		sys-apps/systemd
		sys-apps/systemd-utils
	)
	sys-apps/util-linux
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libdrm
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/teamspeak6-client/chrome-sandbox
	opt/teamspeak6-client/hotkey_helper
	opt/teamspeak6-client/libavcodec.so.62
	opt/teamspeak6-client/libavfilter.so.11
	opt/teamspeak6-client/libavformat.so.62
	opt/teamspeak6-client/libavutil.so.60
	opt/teamspeak6-client/libcef.so
	opt/teamspeak6-client/libEGL.so
	opt/teamspeak6-client/libGLESv2.so
	opt/teamspeak6-client/libswresample.so.6
	opt/teamspeak6-client/libswscale.so.9
	opt/teamspeak6-client/libtschat_client_lib.so
	opt/teamspeak6-client/libtschat_client_lib_export.so
	opt/teamspeak6-client/libvdpau.so.1
	opt/teamspeak6-client/libvk_swiftshader.so
	opt/teamspeak6-client/libvulkan.so.1
	opt/teamspeak6-client/patcher
	opt/teamspeak6-client/soundbackends/libalsa_linux_amd64.so
	opt/teamspeak6-client/TeamSpeak
"

src_prepare() {
	default
}

src_install() {
	exeinto /opt/teamspeak6-client
	doexe chrome-sandbox hotkey_helper patcher TeamSpeak libcef.so libtschat_client_lib.so libtschat_client_lib_export.so

	# Unfortunately we need to use shipped libs as otherwise
	# teamspeak-client crashes using system libs. The only positive
	# is, they only need to be placed in it's teamspeaks home directory.
	doexe libavcodec.so.62 libavfilter.so.11 libavformat.so.62 libavutil.so.60 libswresample.so.6 libswscale.so.9
	doexe libEGL.so libGLESv2.so libvdpau.so.1 libvk_swiftshader.so libvulkan.so.1

	insinto /opt/teamspeak6-client
	doins *.bin *.dat *.json *.pak
	doins -r html licenses locales soundbackends

	dodir /opt/bin
	dosym ../teamspeak6-client/TeamSpeak /opt/bin/ts6client

	for iconsize in 48 128 256; do
		newicon -s ${iconsize} logo-${iconsize}.png teamspeak6.png
	done

	make_desktop_entry \
		/opt/bin/ts6client "Teamspeak 6 Client" \
		"teamspeak6" "Audio;AudioVideo;Network"

	dodoc docs/*
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
