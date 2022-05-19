# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg

DESCRIPTION="Unofficial electron-based wrapper around WhatsApp Web"
HOMEPAGE="https://github.com/diospiroverde/WazzApp"
SRC_URI="https://lx-dynamics.com/wazzapp-${PV}.x86_64.rpm"
S="${WORKDIR}"

KEYWORDS="-* ~amd64"
# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"

RDEPEND="
	app-accessibility/at-spi2-atk
	app-accessibility/at-spi2-core
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="opt/wazzapp/*"

src_prepare() {
	default
	# Fix desktop file to pass validation
	sed -i -e '/MimeType=whatsapp/d' usr/share/applications/wazzapp.desktop || die
}

src_install() {
	mv "${S}"/* "${ED}" || die
}
