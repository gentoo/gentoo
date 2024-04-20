# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg-utils

MY_PN="Bitwarden"

DESCRIPTION="Bitwarden password manager desktop client"
HOMEPAGE="https://bitwarden.com/"
SRC_URI="https://github.com/bitwarden/clients/releases/download/desktop-v${PV}/Bitwarden-${PV}-amd64.deb"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libxshmfence
	x11-libs/libXtst
	x11-libs/pango
"
IDEPEND="
	dev-util/desktop-file-utils
	dev-util/gtk-update-icon-cache
"

QA_PREBUILT="
	opt/Bitwarden/*.so*
	opt/Bitwarden/bitwarden
	opt/Bitwarden/chrome-sandbox
	opt/Bitwarden/chrome_crashpad_handler
"

src_install() {
	insinto /opt
	doins -r opt/${MY_PN}
	fperms 755 /opt/Bitwarden/bitwarden
	fperms 4755 /opt/Bitwarden/chrome-sandbox

	domenu usr/share/applications/bitwarden.desktop

	local x
	for x in 16 32 64 128 256 512; do
		doicon -s ${x} usr/share/icons/hicolor/${x}*/*
	done
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
