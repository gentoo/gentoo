# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Microsoft Teams, an Office 365 multimedia collaboration client, pre-release"
HOMEPAGE="https://teams.microsoft.com/downloads#allDevicesSection"
SRC_URI="teams_1.3.00.958_amd64.deb"

LICENSE="ms-teams-pre"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="fetch mirror splitdebug"
IUSE=""

QA_PREBUILT="*"

# libasound2 (>= 1.0.16), libatk-bridge2.0-0 (>= 2.5.3), libatk1.0-0 (>= 1.12.4), libc6 (>= 2.17), libcairo2 (>= 1.6.0), libcups2 (>= 1.4.0),
# libexpat1 (>= 2.0.1), libgcc1 (>= 1:3.0), libgdk-pixbuf2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.35.8), libgtk-3-0 (>= 3.9.10), libnspr4 (>= 2:4.9-2~), libnss3
# (>= 2:3.22), libpango-1.0-0 (>= 1.14.0), libpangocairo-1.0-0 (>= 1.14.0), libsecret-1-0 (>= 0.7), libuuid1 (>= 2.16), libx11-6 (>= 2:1.4.99.1), libx11-xcb1,
# libxcb1 (>= 1.6), libxcomposite1 (>= 1:0.3-1), libxcursor1 (>> 1.1.2), libxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxi6 (>= 2:1.2.99.4), libxkbfile1,
# libxrandr2 (>= 2:1.2.99.3), libxrender1, libxss1, libxtst6, apt-transport-https, libfontconfig1 (>= 2.11.0), libdbus-1-3 (>= 1.6.18), libstdc++6 (>= 4.8.1)
RDEPEND="
	media-libs/alsa-lib
	app-accessibility/at-spi2-atk
	dev-libs/atk
	x11-libs/cairo
	net-print/cups
	dev-libs/expat
	x11-libs/gdk-pixbuf
	dev-libs/glib
	x11-libs/gtk+:3
	dev-libs/nspr
	dev-libs/nss
	x11-libs/pango
	x11-libs/cairo
	app-crypt/libsecret
	sys-apps/util-linux
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	media-libs/fontconfig
	sys-apps/dbus
	gnome-base/libgnome-keyring
"

src_unpack() {
	default
	mkdir "${S}" || die
	cd "${S}" || die
	unpack ../data.tar.xz
}

src_install() {
	mv -v "${S}/"* "${ED}/" || die
}
