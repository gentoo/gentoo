# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/t4k-common/t4k-common-0.1.1.ebuild,v 1.3 2013/02/25 12:17:36 ago Exp $

EAPI=5
inherit eutils

DESCRIPTION="A library of code shared between tuxmath and tuxtype"
HOMEPAGE="http://tux4kids.alioth.debian.org/tuxmath/download.php"
SRC_URI="http://alioth.debian.org/frs/download.php/3540/t4k_common-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs svg"

RDEPEND="dev-libs/libxml2:2
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-net
	media-libs/sdl-ttf
	media-libs/sdl-pango
	svg? (
		gnome-base/librsvg:2
		media-libs/libpng:0
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/t4k_common-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng.patch
}

src_configure() {
	econf \
		$(usex svg "" "--without-rsvg") \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
}
