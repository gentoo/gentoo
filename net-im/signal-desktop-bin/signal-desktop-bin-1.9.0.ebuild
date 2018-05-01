# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin/}"

inherit gnome2-utils pax-utils unpacker xdg-utils
DESCRIPTION="Allows you to send and receive messages of Signal Messenger on your computer"
HOMEPAGE="https://signal.org/ https://github.com/WhisperSystems/Signal-Desktop"
SRC_URI="https://updates.signal.org/desktop/apt/pool/main/s/${MY_PN}/${MY_PN}_${PV}_amd64.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ayatana"

RESTRICT="bindist mirror"

RDEPEND="
	gnome-base/gconf:2
	dev-libs/nss
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	net-print/cups
	ayatana? ( dev-libs/libappindicator:3 )
	"

QA_PREBUILT="opt/Signal/signal-desktop
	opt/Signal/libnode.so
	opt/Signal/libffmpeg.so"

S="${WORKDIR}"

src_install() {
	insinto /
	dodoc -r usr/share/doc/signal-desktop/.
	doins -r opt
	insinto /usr/share
	doins -r usr/share/applications
	doins -r usr/share/icons
	fperms +x /opt/Signal/signal-desktop
	pax-mark m opt/Signal/signal-desktop

	dosym ../../opt/Signal/${MY_PN} /usr/bin/${MY_PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
