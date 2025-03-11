# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper xdg

DESCRIPTION="GUI for MongoDB"
HOMEPAGE="https://mongodb.com/compass https://github.com/mongodb-js/compass"
SRC_URI="https://github.com/mongodb-js/compass/releases/download/v${PV}/mongodb-compass_${PV}_amd64.deb"
S=${WORKDIR}

LICENSE="SSPL-1"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	dev-libs/nss
	dev-libs/openssl:0/3
	media-libs/alsa-lib
	media-libs/mesa
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/zlib
	virtual/secret-service
	x11-libs/cairo
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
QA_PREBUILT="
	usr/lib/mongodb-compass/.*
"

src_install() {
	insinto /usr/lib/mongodb-compass
	doins -r usr/lib/mongodb-compass/.

	fperms +x "/usr/lib/mongodb-compass/MongoDB Compass"
	fperms 4755 /usr/lib/mongodb-compass/{chrome_crashpad_handler,chrome-sandbox}

	domenu usr/share/applications/mongodb-compass.desktop
	doicon usr/share/pixmaps/mongodb-compass.png

	make_wrapper mongodb-compass "'/usr/lib/mongodb-compass/MongoDB Compass'"
}
