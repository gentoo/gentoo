# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm xdg

DESCRIPTION="The Ultimate Open Source Web Chat Platform"
HOMEPAGE="https://rocket.chat"
SRC_URI="https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${PV}/rocketchat-${PV}-linux-x86_64.rpm"
S="${WORKDIR}"

KEYWORDS="-* ~amd64"
LICENSE="MIT"
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
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXScrnSaver
	x11-libs/pango
"

QA_PREBUILT="opt/Rocket.Chat/*"

src_install() {
	# remove files useless for Gentoo
	rm -r usr/lib || die
	mv "${S}"/* "${ED}" || die
}
