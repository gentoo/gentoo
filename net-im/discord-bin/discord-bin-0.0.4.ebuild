# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=${PN/-bin/}
inherit eutils gnome2-utils unpacker

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
	opt/discord/share/discord/Discord
	opt/discord/share/discord/libnode.so
	opt/discord/share/discord/libffmpeg.so
"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	sed -i \
		-e "s:/usr/share/discord/Discord:discord:g" \
		usr/share/${MY_PN}/${MY_PN}.desktop || die
}

src_install() {
	insinto /opt/${MY_PN}
	doins -r usr/.

	fperms +x /opt/${MY_PN}/bin/${MY_PN}
	dosym ../../opt/${MY_PN}/bin/${MY_PN} /usr/bin/${MY_PN}
	dosym ../../../opt/${MY_PN}/share/applications/${MY_PN}.desktop \
		/usr/share/applications/${MY_PN}.desktop
	dosym ../../../opt/${MY_PN}/share/pixmaps/${MY_PN}.png \
		/usr/share/pixmaps/${MY_PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
