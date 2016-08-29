# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker xdg gnome2-utils

DESCRIPTION="Official RuneScape NXT client launcher"
HOMEPAGE="http://www.runescape.com"

SRC_URI="http://content.runescape.com/downloads/ubuntu/pool/non-free/r/${PN}/${PN}_${PV}_amd64.deb"

QA_PREBUILT="/opt/runescape-launcher/runescape"

SLOT="0"

IUSE="kde"

KEYWORDS="-* ~amd64"

LICENSE="RuneScape-EULA"
RESTRICT="bindist mirror strip"

S="${WORKDIR}"

RDEPEND="
	media-libs/libpng:1.2
	>=media-libs/libsdl2-2.0.2
	>=media-libs/glew-1.10.0:0/1.10
	>=media-libs/libvorbis-1.3.2
	>=net-libs/webkit-gtk-2.4.8:2
	>=net-misc/curl-7.35.0
"

src_prepare() {
	# Fix path in launcher script
	sed -i "s:/usr/share/games/$PN:/opt/$PN:" usr/bin/$PN || die

	# Add missing trailing semicolon to .desktop MimeType entry
	sed -i '/MimeType=/{/;$/!{s/$/;/}}' usr/share/applications/${PN}.desktop || die

	# Fix path to launcher script
	sed -i "s:/usr/bin/$PN:/opt/bin/$PN:" usr/share/applications/${PN}.desktop || die

	xdg_src_prepare

	eapply_user
}

src_install() {
	into /opt
	dobin usr/bin/$PN
	dodoc usr/share/doc/$PN/*

	exeinto /opt/$PN
	doexe usr/share/games/$PN/runescape

	insinto /usr/share/applications
	doins usr/share/applications/${PN}.desktop

	insinto /usr/share/icons
	doins -r usr/share/icons/hicolor

	if use kde ; then
		insinto /usr/share/kde4
		doins -r usr/share/kde4/services
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
