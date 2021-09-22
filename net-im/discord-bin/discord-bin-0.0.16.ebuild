# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/-bin/}
MY_BIN="D${MY_PN/d/}"

inherit desktop linux-info pax-utils unpacker xdg

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${MY_PN}-${PV}.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror bindist"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
"

S="${WORKDIR}"

QA_PREBUILT="
	opt/discord/${MY_BIN}
	opt/discord/chrome-sandbox
	opt/discord/libffmpeg.so
	opt/discord/libvk_swiftshader.so
	opt/discord/libvulkan.so
	opt/discord/libEGL.so
	opt/discord/libGLESv2.so
	opt/discord/libVkICD_mock_icd.so
	opt/discord/swiftshader/libEGL.so
	opt/discord/swiftshader/libGLESv2.so
	opt/discord/swiftshader/libvk_swiftshader.so
"

CONFIG_CHECK="~USER_NS"

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/discord/Discord:/opt/${MY_PN}/${MY_BIN}:g" \
		usr/share/${MY_PN}/${MY_PN}.desktop || die
}

src_install() {
	doicon usr/share/${MY_PN}/${MY_PN}.png
	domenu usr/share/${MY_PN}/${MY_PN}.desktop

	insinto /opt/${MY_PN}
	doins -r usr/share/${MY_PN}/.
	fperms +x /opt/${MY_PN}/${MY_BIN}
	dosym ../../opt/${MY_PN}/${MY_BIN} usr/bin/${MY_PN}

	pax-mark -m "${ED}"/opt/${MY_PN}/${MY_PN}
}
