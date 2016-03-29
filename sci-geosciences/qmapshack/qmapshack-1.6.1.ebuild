# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit cmake-utils

DESCRIPTION="GPS mapping utility"
HOMEPAGE="https://bitbucket.org/maproom/qmapshack/wiki/Home"
SRC_URI="https://bitbucket.org/maproom/${PN}/downloads/${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="dev-qt/qtwebkit:5
	dev-qt/qtscript:5
	dev-qt/qtprintsupport:5
	dev-qt/qtdbus:5
	>=sci-geosciences/routino-3.0_p1
	sci-libs/gdal
	sci-libs/proj"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"
