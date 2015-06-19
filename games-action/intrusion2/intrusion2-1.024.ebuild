# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/intrusion2/intrusion2-1.024.ebuild,v 1.6 2015/06/01 22:05:45 mr_bones_ Exp $

EAPI=5
inherit eutils games

USELESS_ID="1370288626"
DESCRIPTION="Fast paced action sidescroller set in a sci-fi environment"
HOMEPAGE="http://intrusion2.com"
SRC_URI="intrusion2-${USELESS_ID}-bin"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist fetch"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/${PN}"

RDEPEND="
	amd64? (
		>=dev-libs/glib-2.34.3:2[abi_x86_32(-)]
		>=dev-libs/atk-2.10.0[abi_x86_32(-)]
		>=x11-libs/gdk-pixbuf-2.30.7[abi_x86_32(-)]
		>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
		>=x11-libs/pango-1.36.3[abi_x86_32(-)]
		>=media-libs/gst-plugins-base-0.10.36[abi_x86_32(-)]
		>=media-libs/gstreamer-0.10.36-r2[abi_x86_32(-)]
		>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
		>=media-libs/freetype-2.5.0.1[abi_x86_32(-)]
		>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
		>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libXinerama-1.1.3[abi_x86_32(-)]
		>=x11-libs/libXtst-1.2.1-r1[abi_x86_32(-)]
	)
	x86? (
		dev-libs/glib:2
		dev-libs/atk
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
		x11-libs/pango
		media-libs/gst-plugins-base
		media-libs/gstreamer
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXtst
	)"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_unpack() { :; }

src_install() {
	exeinto "${MYGAMEDIR}"
	newexe "${DISTDIR}"/${SRC_URI} ${PN}

	games_make_wrapper ${PN} "${MYGAMEDIR}/${PN}"
	make_desktop_entry ${PN}

	prepgamesdirs
}
