# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pathfinder/pathfinder-1.7.45.ebuild,v 1.1 2014/01/10 18:27:44 mabi Exp $

EAPI="4"

inherit fox

DESCRIPTION="File manager based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+jpeg +png +tiff"

DEPEND="
	x11-libs/fox:1.7
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng:0 )
	tiff? ( media-libs/tiff:0 )"

RDEPEND="${DEPEND}"

src_configure() {
	FOXCONF="$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable tiff)" fox_src_configure
}
