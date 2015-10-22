# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_MINIMAL="4.10"
VIRTUALX_REQUIRED="test"
inherit kde4-base

MY_PV=${PV/_/-}
MY_P="digikam-${MY_PV}"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

DESCRIPTION="Wrapper library for world map components as marble, openstreetmap and googlemap"
HOMEPAGE="http://www.digikam.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""
SLOT=4

DEPEND="
	kde-apps/libkexiv2:4=
	kde-apps/marble:4=[kde,plasma]
"
RDEPEND=${DEPEND}

S="${WORKDIR}/${MY_P}/extra/${PN}"
