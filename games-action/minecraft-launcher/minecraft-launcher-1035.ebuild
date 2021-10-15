# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

# We can find which url we need for the latest release here:
# https://launchermeta.mojang.com/v1/products/launcher/6f083b80d5e6fabbc4236f81d0d8f8a350c665a9/linux.json

DESCRIPTION="An open-world game whose gameplay revolves around breaking and placing blocks"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://launcher.mojang.com/v1/objects/ce9e6169550628003e22de8086e9fe1186c2285e/minecraft-launcher -> ${P}
	https://launcher.mojang.com/download/minecraft-launcher.svg"

KEYWORDS="-* ~amd64"
LICENSE="Mojang"
SLOT="0"

RESTRICT="bindist mirror"

RDEPEND="
	>=x11-libs/gtk+-2.24.32-r1[X(+)]
	app-crypt/libsecret
	dev-libs/nss
	dev-libs/libbsd
	|| ( dev-libs/libffi-compat:7 dev-libs/libffi:0/7 )
	dev-libs/libpcre
	media-libs/alsa-lib
	media-libs/openal
	net-libs/gnutls[idn]
	net-misc/curl[adns]
	net-print/cups
	sys-apps/dbus
	virtual/jre:1.8
	virtual/opengl
	x11-apps/xrandr
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/xcb-util
"

S="${WORKDIR}"

QA_PREBUILT="
	/usr/bin/minecraft-launcher
"

src_install() {
	newbin "${DISTDIR}/${P}" ${PN}

	doicon -s scalable "${DISTDIR}/${PN}.svg"
	make_desktop_entry ${PN} "Minecraft" ${PN} Game
}
