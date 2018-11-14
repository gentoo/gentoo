# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="Bhutanese style dbu-can font for Tibetan/Dzongkha text named after Mt Jomolhari"
HOMEPAGE="http://chris.fynn.googlepages.com/jomolhari"
SRC_URI="mirror://nongnu/free-tibetan/${PN}/${PN}-alpha${PV:(-2)}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
