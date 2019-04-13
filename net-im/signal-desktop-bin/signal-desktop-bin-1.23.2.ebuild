# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin/}"

inherit gnome2-utils pax-utils unpacker xdg-utils

DESCRIPTION="Allows you to send and receive messages of Signal Messenger on your computer"
HOMEPAGE="https://signal.org/
	https://github.com/WhisperSystems/Signal-Desktop"
SRC_URI="https://updates.signal.org/desktop/apt/pool/main/s/${MY_PN}/${MY_PN}_${PV}_amd64.deb"

LICENSE="GPL-3 MIT MIT-with-advertising BSD-1 BSD-2 BSD Apache-2.0 ISC openssl ZLIB APSL-2 icu Artistic-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND="
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/mesa
	net-print/cups
	x11-libs/gtk+:3[X]
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	"

QA_PREBUILT="opt/Signal/signal-desktop
	opt/Signal/libffmpeg.so
	opt/Signal/libGLESv2.so
	opt/Signal/libnode.so
	opt/Signal/libVkICD_mock_icd.so
	opt/Signal/swiftshader/libGLESv2.so"

S="${WORKDIR}"

src_prepare(){
	default
	sed -e 's|\("/opt/Signal/signal-desktop"\)|\1 --start-in-tray|g' \
		-i usr/share/applications/signal-desktop.desktop || die
	unpack usr/share/doc/signal-desktop/changelog.gz
}

src_install() {
	insinto /
	dodoc changelog
	doins -r opt
	insinto /usr/share
	doins -r usr/share/applications
	doins -r usr/share/icons
	fperms +x /opt/Signal/signal-desktop
	pax-mark m opt/Signal/signal-desktop

	dosym ../../opt/Signal/${MY_PN} /usr/bin/${MY_PN}
	dosym ../../usr/lib64/libEGL.so opt/Signal/libEGL.so
	dosym ../../../usr/lib64/libEGL.so opt/Signal/swiftshader/libEGL.so
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
