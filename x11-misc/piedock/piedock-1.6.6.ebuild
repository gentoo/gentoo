# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="A little bit like the famous OS X dock but in shape of a pie menu"
HOMEPAGE="http://markusfisch.de/PieDock"
SRC_URI="http://markusfisch.de/downloads/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk kde"

RDEPEND="
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXrender
	gtk? (
		dev-libs/atk
		dev-libs/glib
		x11-libs/gdk-pixbuf
		x11-libs/gtk+:2
	)
	kde? (
		kde-base/kdelibs:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
"
DEPEND="${RDEPEND}"

DOCS=( res/${PN}rc.sample AUTHORS ChangeLog NEWS )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.6.1-signals.patch
}

src_configure() {
	econf \
		$(use_enable gtk) \
		$(use_enable kde) \
		--bindir="${EPREFIX}"/usr/bin \
		--enable-xft \
		--enable-xmu \
		--enable-xrender
}
