# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop verify-sig

DESCRIPTION="Official Tor Browser"
HOMEPAGE="https://www.torproject.org"
TOR_SRC_BASE_URI="https://www.torproject.org/dist/torbrowser/"
SRC_URI="
	${TOR_SRC_BASE_URI}/${PV}/tor-browser-linux-x86_64-${PV}.tar.xz
	verify-sig? ( ${TOR_SRC_BASE_URI}/${PV}/tor-browser-linux-x86_64-${PV}.tar.xz.asc )
"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/torproject.org.asc"

S="${WORKDIR}"/tor-browser/Browser
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-tor-20250612 )"
RDEPEND="
	app-accessibility/at-spi2-core
	dev-libs/glib
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/pango
"

OPT_PATH=/opt/torbrowser-bin

src_install() {
	insinto "${OPT_PATH}"
	doins -r "${S}"/*

	fperms 0755 \
		"${OPT_PATH}"/abicheck \
		"${OPT_PATH}"/execdesktop \
		"${OPT_PATH}"/firefox \
		"${OPT_PATH}"/firefox.real \
		"${OPT_PATH}"/glxtest \
		"${OPT_PATH}"/start-tor-browser \
		"${OPT_PATH}"/updater \
		"${OPT_PATH}"/vaapitest \
		"${OPT_PATH}"/TorBrowser/Tor/tor

	touch "${D}${OPT_PATH}/is-packaged-app" || die

	make_desktop_entry "/opt/torbrowser-bin/start-tor-browser" \
		"Tor Browser" \
		"/opt/torbrowser-bin/browser/chrome/icons/default/default128.png" \
		"Network;Security;WebBrowser"
}
