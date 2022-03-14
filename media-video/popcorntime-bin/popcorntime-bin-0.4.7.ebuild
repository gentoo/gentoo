# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="BitTorrent client that includes an integrated media player"
HOMEPAGE="https://github.com/popcorn-official/popcorn-desktop"
SRC_URI="
	amd64? ( https://github.com/popcorn-official/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-amd64.deb )
	x86? ( https://github.com/popcorn-official/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-i386.deb )
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
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

QA_PREBUILT="opt/Popcorn-Time/*"

src_install() {
	mv "${S}"/* "${ED}" || die
	dosym ../Popcorn-Time/Popcorn-Time /opt/bin/popcorntime
}
