# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS=""
KDE_MINIMAL="4.10"
CMAKE_MIN_VERSION=2.8
inherit kde4-base

MY_PV=${PV/_/-}
MY_P="digikam-${MY_PV}"
SRC_URI="mirror://kde/stable/digikam/${MY_P}.tar.bz2"

DESCRIPTION="Library for accessing the features of social networking site vkontakte.ru"
HOMEPAGE="http://www.digikam.org/"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="debug"
SLOT=4

DEPEND=">=dev-libs/qjson-0.7.0"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}/extra/${PN}

PATCHES=( "${FILESDIR}/${PN}-2.2.0-libdir.patch" )

src_configure() {
	mycmakeargs=(
		-DFORCED_UNBUNDLE=ON
	)
	kde4-base_src_configure
}
