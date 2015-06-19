# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pathfinder/pathfinder-1.6.36.ebuild,v 1.7 2011/11/12 10:50:41 jlec Exp $

EAPI="1"

inherit fox

DESCRIPTION="File manager based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ppc ppc64 ~sparc x86"
IUSE="jpeg png tiff"

DEPEND="
	x11-libs/fox:1.6
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng:0 )
	tiff? ( media-libs/tiff:0 )"

RDEPEND="${DEPEND}"

FOXCONF="$(use_enable jpeg) \
	$(use_enable png) \
	$(use_enable tiff)"
