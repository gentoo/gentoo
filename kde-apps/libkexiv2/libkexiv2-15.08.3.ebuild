# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE Image Plugin Interface: an exiv2 library wrapper"
KEYWORDS="amd64 ~arm x86"
IUSE="debug +xmp"

DEPEND="
	>=media-gfx/exiv2-0.24:=[xmp=]
	virtual/jpeg:0
"
RDEPEND="${DEPEND}"
