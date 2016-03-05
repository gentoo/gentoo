# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Wrapper library for world map components as marble, openstreetmap and googlemap"
HOMEPAGE="https://www.digikam.org/"

LICENSE="GPL-2"
KEYWORDS=" amd64 ~x86"
IUSE=""

DEPEND="
	kde-apps/libkexiv2:4=
	kde-apps/marble:4=[kde,plasma]
"
RDEPEND="${DEPEND}
	!media-libs/libkgeomap
"
