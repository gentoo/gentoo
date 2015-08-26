# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == *9999 ]]; then
	KMNAME="kdesupport"
fi
KDE_AUTODEPS="false"
KDE_SCM="svn"
inherit kde5

DESCRIPTION="Oxygen SVG icon theme"
HOMEPAGE="http://www.oxygen-icons.org/"
if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI=" !sources? ( https://dev.gentoo.org/~johu/distfiles/${P}.repacked.tar.xz )
		sources? ( ${SRC_URI} )
	"
fi

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="sources"

RDEPEND="!kde-apps/oxygen-icons:4"
