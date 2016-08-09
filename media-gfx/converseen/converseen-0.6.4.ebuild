# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Batch image converter and resizer based on ImageMagick"
HOMEPAGE="http://converseen.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug l10n_cs l10n_de l10n_es l10n_fr l10n_hu l10n_it l10n_pl l10n_pt l10n_ru l10n_tr"

# FIXME: graphicsmagick dependency does not work properly, failures when compiling
#	|| ( media-gfx/imagemagick[cxx] media-gfx/graphicsmagick[cxx,imagemagick-compat] )
RDEPEND="
	dev-qt/qtgui:4
	media-gfx/imagemagick[cxx]
"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_prepare() {
	default

	local x
	for x in ${IUSE}; do
		if ! use $x && [[ $x == l10n_* ]]; then
			rm -f "loc/${PN}_${x#l10n_}"* || die
			sed -i -e "/${PN}_${x#l10n_}.*\.ts/d" CMakeLists.txt || die
		fi
	done
}
