# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin/}"

inherit pax-utils unpacker xdg

DESCRIPTION="Allows you to send and receive messages of Signal Messenger on your computer"
HOMEPAGE="https://signal.org/
	https://github.com/signalapp/Signal-Desktop"
SRC_URI="https://updates.signal.org/desktop/apt/pool/s/${MY_PN}/${MY_PN}_${PV}_amd64.deb"
S="${WORKDIR}"

# Corresponding Source: https://github.com/signalapp/Signal-Desktop/blob/v${PV}/LICENSE
LICENSE="AGPL-3"
# From www-client/chromium for the bundled Electron runtime
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD FFT2D FTL"
LICENSE+=" IJG ISC LGPL-2 LGPL-2.1 MIT MPL-1.1 MPL-2.0 Ms-PL PSF-2 SGI-B-2.0 SSLeay SunSoft Unicode-3.0"
LICENSE+=" Unicode-DFS-2015 Unlicense UoI-NCSA ZLIB libtiff openssl"
# From net-libs/nodejs
LICENSE+=" Apache-1.1 BlueOak-1.0.0"
SLOT="0"
KEYWORDS="-* amd64"
RESTRICT="splitdebug"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=media-fonts/noto-emoji-20231130
	media-libs/alsa-lib
	media-libs/libpulse
	media-libs/mesa[opengl]
	net-print/cups
	sys-apps/dbus
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="
	opt/Signal/chrome_crashpad_handler
	opt/Signal/chrome-sandbox
	opt/Signal/libEGL.so
	opt/Signal/libGLESv2.so
	opt/Signal/libffmpeg.so
	opt/Signal/libvk_swiftshader.so
	opt/Signal/libvulkan.so.1
	opt/Signal/resources/app.asar.unpacked/node_modules/*
	opt/Signal/signal-desktop
	opt/Signal/swiftshader/libEGL.so
	opt/Signal/swiftshader/libGLESv2.so"

src_prepare() {
	default
	sed -e "s|^Exec=/opt/Signal/signal-desktop|Exec=${MY_PN}|" \
		-i usr/share/applications/signal-desktop.desktop || die
	unpack usr/share/doc/signal-desktop/changelog.gz

	# https://github.com/signalapp/Signal-Desktop/issues/6239
	# https://github.com/signalapp/Signal-Desktop/issues/6122
	# fixes app icon issues on wayland because "app-id" is "signal"
	# and desktop file needs to match
	mv usr/share/applications/signal-desktop.desktop \
		usr/share/applications/signal.desktop || die
}

src_install() {
	insinto /
	dodoc changelog
	doins -r opt
	insinto /usr/share

	doins -r usr/share/applications
	doins -r usr/share/icons
	fperms +x /opt/Signal/signal-desktop /opt/Signal/chrome-sandbox /opt/Signal/chrome_crashpad_handler
	fperms u+s /opt/Signal/chrome-sandbox
	pax-mark m opt/Signal/signal-desktop opt/Signal/chrome-sandbox opt/Signal/chrome_crashpad_handler

	dosym ../../opt/Signal/${MY_PN} /usr/bin/${MY_PN}
}
