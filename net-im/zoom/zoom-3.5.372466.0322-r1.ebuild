# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils xdg-utils

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://zoom.us/"
SRC_URI="amd64? ( https://zoom.us/client/${PV}/${PN}_x86_64.tar.xz -> ${P}_x86_64.tar.xz )
	x86? ( https://zoom.us/client/${PV}/${PN}_i686.tar.xz -> ${P}_i686.tar.xz )"
S="${WORKDIR}/${PN}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="mirror bindist strip"

RDEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	media-libs/libglvnd
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms"

QA_PREBUILT="opt/zoom/*"

src_install() {
	insinto /opt/zoom
	exeinto /opt/zoom
	doins -r json sip timezones translations
	doins *.pcm *.pem *.sh Embedded.properties version.txt
	use amd64 && doins icudtl.dat
	doexe zoom{,.sh,linux} zopen ZoomLauncher
	make_wrapper zoom ./zoom /opt/zoom
	make_desktop_entry "zoom %U" Zoom audio-headset "" \
		"MimeType=x-scheme-handler/zoommtg;application/x-zoom;"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
