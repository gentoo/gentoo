# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="Bhutanese style dbu-can font for Tibetan and Dzongkha text named after Mt Jomolhari"
HOMEPAGE="http://chris.fynn.googlepages.com/jomolhari"
SRC_URI="http://download.savannah.nongnu.org/releases/free-tibetan/${PN}/${PN}-alpha${PV:(-2)}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
