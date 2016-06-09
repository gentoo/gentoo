# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CHROMIUM_LANGS="
	af az be bg bn ca cs da de el en_GB en_US es_419 es fil fi fr_CA fr fy gd
	he hi hr hu id it ja kk ko lt lv me mk ms nb nl nn pa pl pt_BR pt_PT ro ru
	sk sr sv sw ta te th tr uk uz vi zh_CN zh_TW zu
"
inherit chromium multilib unpacker

DESCRIPTION="A fast and secure web browser"
HOMEPAGE="http://www.opera.com/"
LICENSE="OPERA-2014"
SLOT="0"
SRC_URI_BASE="http://get.geo.opera.com/pub/"
SRC_URI="
	amd64? ( "${SRC_URI_BASE}${PN}/desktop/${PV}/linux/${PN}-stable_${PV}_amd64.deb" )
	x86? ( "${SRC_URI_BASE}${PN}/desktop/${PV}/linux/${PN}-stable_${PV}_i386.deb" )
"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/openssl-1.0.1:0
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
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
	x11-libs/libnotify
	x11-libs/pango[X]
"

QA_PREBUILT="*"
S=${WORKDIR}
OPERA_HOME="usr/$(get_libdir)/${PN}"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	mv usr/lib/x86_64-linux-gnu usr/$(get_libdir) || die
	rm -r usr/lib || die

	rm usr/bin/${PN} || die

	rm usr/share/doc/${PN}-stable/copyright || die
	mv usr/share/doc/${PN}-stable usr/share/doc/${PF} || die

	pushd "${OPERA_HOME}/localization" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	sed -i \
		-e 's|^TargetEnvironment|X-&|g' \
		usr/share/applications/${PN}.desktop || die
}

src_install() {
	mv * "${D}" || die
	dosym ../$(get_libdir)/${PN}/${PN} /usr/bin/${PN}
	fperms 4711 /usr/$(get_libdir)/${PN}/opera_sandbox
}
