# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/-bin/}
MY_BIN="D${MY_PN/d/}"
inherit eutils gnome2-utils unpacker desktop xdg-utils

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${MY_PN}-${PV}.deb"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups
	sys-apps/dbus
	sys-libs/libcxx
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
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

S=${WORKDIR}

RESTRICT="mirror bindist"

QA_PREBUILT="
	opt/discord/${MY_BIN}
	opt/discord/libnode.so
	opt/discord/libffmpeg.so
"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/discord/Discord:/opt/${MY_PN}/${MY_BIN}:g" \
		usr/share/${MY_PN}/${MY_PN}.desktop || die
}

src_install() {
	domenu opt/${MY_PN}/${MY_PN}.desktop
	doicon opt/${MY_PN}/${MY_PN}.png

	insinto /opt
	doins -r usr/share/${MY_PN}
	fperms +x /opt/${MY_PN}/${MY_BIN}
	dosym ../../opt/${MY_PN}/${MY_BIN} usr/bin/${MY_PN}
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
