# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="universal visual notification dockapp"
HOMEPAGE="http://swapspace.net/~matt/wmmsg"
SRC_URI="http://swapspace.net/~matt/wmmsg/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/imlib2
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-libs/libXt"

DOCS="AUTHORS ChangeLog README wmmsgrc"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-use_gtk2.patch \
		"${FILESDIR}"/${P}-alt-desktop.patch \
		"${FILESDIR}"/${P}-list.patch

	eautoreconf
}
