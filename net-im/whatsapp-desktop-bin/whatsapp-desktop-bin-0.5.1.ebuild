# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

DESCRIPTION="Unofficial electron-based wrapper around WhatsApp Web"
HOMEPAGE="https://github.com/oOthkOo/whatsapp-desktop"
SRC_URI="
	amd64? ( https://github.com/oOthkOo/whatsapp-desktop/releases/download/v${PV}/whatsapp-desktop-x64.deb -> ${PN}-amd64-${PV}.deb )
	x86? ( https://github.com/oOthkOo/whatsapp-desktop/releases/download/v${PV}/whatsapp-desktop-x32.deb -> ${PN}-x86-${PV}.deb )
"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/libappindicator
	dev-libs/nspr
	dev-libs/nss
	media-fonts/noto-emoji
	media-libs/alsa-lib
	net-print/cups
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXScrnSaver
	x11-libs/pango
"

QA_PREBUILT="/opt/whatsapp-desktop/*"

S="${WORKDIR}"

src_install() {
	cp -a "${S}"/* "${ED}" || die
}
