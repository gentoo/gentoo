# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit fox

DESCRIPTION="File manager based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE="+jpeg +png +tiff"

DEPEND="
	x11-libs/fox:1.7
	x11-libs/libICE
	x11-libs/libSM
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng:0 )
	tiff? ( media-libs/tiff:0 )"

RDEPEND="${DEPEND}"

src_configure() {
	FOXCONF="$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable tiff)" fox_src_configure
}
