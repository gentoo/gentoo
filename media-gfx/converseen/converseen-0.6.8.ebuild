# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/converseen/converseen-0.6.8.ebuild,v 1.1 2014/04/08 17:32:26 maksbotan Exp $

EAPI="5"
LANGSLONG="cs_CZ de_DE fr_FR hu_HU it_IT ja_JP pl_PL pt_BR ru_RU tr_TR"
LANGS="es_CL"

inherit cmake-utils

DESCRIPTION="Batch image converter and resizer based on ImageMagick"
HOMEPAGE="http://converseen.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"
for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done
for x in ${LANGSLONG}; do
	IUSE="${IUSE} linguas_${x%_*}"
done

# FIXME: graphicsmagick dependency does not work properly, failures when compiling
#	|| ( media-gfx/imagemagick[cxx] media-gfx/graphicsmagick[cxx,imagemagick] )
RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-gfx/imagemagick[cxx]
"
DEPEND="${RDEPEND}"

DOCS=( README.md )

src_prepare() {
	for x in ${LANGSLONG}; do
		if use !linguas_${x%_*}; then
			rm -f "loc/${PN}_${x}."* || die
			sed -i -e "\,/${PN}_${x}\...,d" CMakeLists.txt || die
		fi
	done
	for x in ${LANGS}; do
		if use !linguas_${x}; then
			rm -f "loc/${PN}_${x}."* || die
			sed -i -e "\,/${PN}_${x}\...,d" CMakeLists.txt || die
		fi
	done
}
