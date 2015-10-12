# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils

DESCRIPTION="a free reimplementation of Impulse Tracker, a program used to create high quality music"
HOMEPAGE="http://eval.sovietrussia.org//wiki/Schism_Tracker"
SRC_URI="http://${PN}.org/dl/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	>=media-libs/libsdl-1.2[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXv
	x11-libs/libXxf86misc"
DEPEND="${RDEPEND}
	virtual/os-headers
	x11-proto/kbproto
	x11-proto/xf86miscproto
	x11-proto/xproto"

DOCS=( AUTHORS NEWS README TODO )

src_install() {
	default
	doicon icons/schism-icon.svg
	newicon icons/schism-icon-48.png schism-icon.png
	make_desktop_entry ${PN} "Schism Tracker" schism-icon
}
