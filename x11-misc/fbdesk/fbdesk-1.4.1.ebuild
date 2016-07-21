# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="fluxbox-util application that creates and manage icons on your Fluxbox desktop"
HOMEPAGE="http://fluxbox.sourceforge.net/fbdesk/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="debug png"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXft
	media-libs/imlib2[X]
	png? ( media-libs/libpng )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-libpng14.patch \
		"${FILESDIR}"/${P}-libpng15.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable png)
}
