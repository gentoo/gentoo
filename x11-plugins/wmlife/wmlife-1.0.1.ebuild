# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmlife/wmlife-1.0.1.ebuild,v 1.6 2014/11/13 16:18:01 voyageur Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="dockapp running Conway's Game of Life (and program launcher)"
HOMEPAGE="http://www.swanson.ukfsn.org/#wmlife"
SRC_URI="http://www.swanson.ukfsn.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext"
EPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

PATCHES=( "${FILESDIR}"/${PN}-1.0.0-stringh.patch
	"${FILESDIR}"/${P}-configure.patch )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.0-stringh.patch
	epatch "${FILESDIR}"/${P}-configure.patch

	eautoreconf
}

src_configure() {
	econf --enable-session
}
