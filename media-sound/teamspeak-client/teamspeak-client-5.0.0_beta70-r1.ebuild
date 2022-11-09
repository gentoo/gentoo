# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="A client software for quality voice communication via the internet"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="https://files.teamspeak-services.com/pre_releases/client/${PV/_/-}/teamspeak-client.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

KEYWORDS=""
LICENSE="teamspeak5 || ( GPL-2 GPL-3 LGPL-3 )"
SLOT="5"

RDEPEND="
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	media-sound/pulseaudio
	net-print/cups
	sys-power/upower
	sys-apps/dbus
	x11-libs/cairo[glib]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
"

RESTRICT="bindist mirror"

QA_PREBUILT="
	opt/teamspeak5-client/chrome-sandbox
	opt/teamspeak5-client/hotkey_helper
	opt/teamspeak5-client/libcef.so
	opt/teamspeak5-client/libtschat_client_lib.so
	opt/teamspeak5-client/libtschat_client_lib_export.so
	opt/teamspeak5-client/patcher
	opt/teamspeak5-client/TeamSpeak
	opt/teamspeak5-client/soundbackends/libalsa_linux_amd64.so
	opt/teamspeak5-client/soundbackends/libpulseaudio_linux_amd64.so
"

src_install() {
	exeinto /opt/teamspeak5-client
	doexe chrome-sandbox hotkey_helper patcher TeamSpeak libcef.so libtschat_client_lib.so libtschat_client_lib_export.so

	insinto /opt/teamspeak5-client
	doins *.bin *.dat *.pak
	doins -r html licenses locales soundbackends

	dodir /opt/bin
	dosym ../teamspeak5-client/TeamSpeak /opt/bin/ts5client

	make_desktop_entry /opt/bin/ts5client "Teamspeak 5 Client" /opt/teamspeak5-client/html/client_ui/images/icons/teamspeak_logo.svg "Audio;AudioVideo;Network"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
