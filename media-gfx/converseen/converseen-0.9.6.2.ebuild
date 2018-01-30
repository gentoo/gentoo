# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Batch image converter and resizer based on ImageMagick"
HOMEPAGE="http://converseen.fasterland.net/"
SRC_URI="https://github.com/Faster3ck/Converseen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# FIXME: graphicsmagick dependency does not work properly, failures when compiling
#	|| ( media-gfx/imagemagick[cxx] media-gfx/graphicsmagick[cxx,imagemagick] )
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-gfx/imagemagick:=[cxx]
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

S="${WORKDIR}/${P^}"

PATCHES=( "${FILESDIR}/${P}-gnuinstalldirs.patch" )
