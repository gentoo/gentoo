# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

inherit optfeature pax-utils unpacker xdg

DESCRIPTION="Allows you to send and receive messages of Signal Messenger on your computer"
HOMEPAGE="https://signal.org/
	https://github.com/signalapp/Signal-Desktop"
SRC_URI="https://updates.signal.org/desktop/apt/pool/main/s/${MY_PN}/${MY_PN}_${PV}_amd64.deb"

LICENSE="GPL-3 MIT MIT-with-advertising BSD-1 BSD-2 BSD Apache-2.0 ISC openssl ZLIB APSL-2 icu Artistic-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND="app-admin/chrpath"
RDEPEND="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[X(+)]
	|| (
		media-sound/pulseaudio
		media-sound/apulse[sdk]
	)
	net-print/cups
	sys-apps/dbus[X]
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libxcb
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

QA_PREBUILT="opt/Signal/signal-desktop
	opt/Signal/chrome-sandbox
	opt/Signal/crashpad_handler
	opt/Signal/libffmpeg.so
	opt/Signal/libGLESv2.so
	opt/Signal/libnode.so
	opt/Signal/libVkICD_mock_icd.so
	opt/Signal/libvk_swiftshader.so
	opt/Signal/swiftshader/libGLESv2.so
	opt/Signal/resources/app.asar.unpacked/node_modules/curve25519-n/build/Release/curve.node
	opt/Signal/resources/app.asar.unpacked/node_modules/@journeyapps/sqlcipher/lib/binding/electron-v8.3-linux-x64/node_sqlite3.node
	opt/Signal/resources/app.asar.unpacked/node_modules/zkgroup/node_modules/ref-napi/build/Release/binding.node
	opt/Signal/resources/app.asar.unpacked/node_modules/ref-napi/build/Release/binding.node
	opt/Signal/resources/app.asar.unpacked/node_modules/ringrtc/build/linux/libringrtc.node
	opt/Signal/resources/app.asar.unpacked/node_modules/ffi-napi/build/Release/ffi_bindings.node
	opt/Signal/resources/app.asar.unpacked/node_modules/sharp/build/Release/sharp.node
	opt/Signal/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/*
	opt/Signal/resources/app.asar.unpacked/node_modules/zkgroup/libzkgroup.so"

RESTRICT="splitdebug"

S="${WORKDIR}"

src_prepare() {
	default
	sed -e 's|\("/opt/Signal/signal-desktop"\)|\1 --start-in-tray|g' \
		-e 's| --no-sandbox||g' \
		-i usr/share/applications/signal-desktop.desktop || die
	unpack usr/share/doc/signal-desktop/changelog.gz
	# Fix Bug 706352
	chrpath opt/Signal/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/libjpeg.so.8.2.2 -r '$ORIGIN:/target/lib' || die
	chrpath opt/Signal/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/libffi.so.6.0.4 -d || die
}

src_install() {
	insinto /
	dodoc changelog
	doins -r opt
	insinto /usr/share
	doins -r usr/share/applications
	doins -r usr/share/icons
	fperms +x /opt/Signal/signal-desktop /opt/Signal/chrome-sandbox
	fperms u+s /opt/Signal/chrome-sandbox
	pax-mark m opt/Signal/signal-desktop opt/Signal/chrome-sandbox

	dosym ../../opt/Signal/${MY_PN} /usr/bin/${MY_PN}
	dosym ../../usr/lib64/libEGL.so opt/Signal/libEGL.so
	dosym ../../../usr/lib64/libEGL.so opt/Signal/swiftshader/libEGL.so
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "using the tray icon in Xfce desktop environments" xfce-extra/xfce4-statusnotifier-plugin
}
