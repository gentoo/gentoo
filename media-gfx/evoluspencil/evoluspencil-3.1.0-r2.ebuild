# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm xdg-utils desktop

MY_PN="${PN/evolus/}"
MY_PV="${PV}.ga"

DESCRIPTION="A simple GUI prototyping tool to create mockups"
HOMEPAGE="https://pencil.evolus.vn/"
SRC_URI="https://pencil.evolus.vn/dl/V${MY_PV}/${MY_PN}-${MY_PV}-1.x86_64.rpm -> ${P}-1.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2
		( app-accessibility/at-spi2-atk dev-libs/atk )
	)
	dev-libs/expat
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
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

S="${WORKDIR}"

# bug 703602
RESTRICT="splitdebug"

QA_PREBUILT="
	opt/${MY_PN}/*.so
	opt/${MY_PN}/chrome-sandbox
	opt/${MY_PN}/pencil
"

src_prepare() {
	default
	rm opt/${MY_PN}-${MY_PV}/${MY_PN}.desktop || die
}

src_install() {
	insinto /opt/${MY_PN}
	doins -r opt/${MY_PN}-${MY_PV}/*

	fperms 755 /opt/${MY_PN}/${MY_PN}
	dosym ../../opt/${MY_PN}/${MY_PN} /usr/bin/evoluspencil

	domenu "${FILESDIR}"/${MY_PN}.desktop

	mkdir -p "${D}"/usr/share/icons/hicolor/256x256/apps/ || die
	mv "${D}"/opt/${MY_PN}/${MY_PN}.png "${D}"/usr/share/icons/hicolor/256x256/apps/ || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
