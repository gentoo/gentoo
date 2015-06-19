# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkgeomap/libkgeomap-4.10.0.ebuild,v 1.2 2015/06/04 19:03:11 kensington Exp $

EAPI=5

MY_PV="${PV/_/-}"
MY_P="digikam-${MY_PV}"

KDE_MINIMAL="4.10"
VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Wrapper library for world map components as marble, openstreetmap and googlemap"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4/2.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	kde-apps/libkexiv2:4=
	kde-apps/marble:4=[kde,plasma]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/extra/${PN}"
