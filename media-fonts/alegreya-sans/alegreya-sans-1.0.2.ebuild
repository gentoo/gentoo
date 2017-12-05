# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit font

DESCRIPTION="A humanist sans-serif typeface with a calligraphic, dynamic feeling"
HOMEPAGE="http://www.huertatipografica.com/fonts/alegreya-sans-ht"
SRC_URI="http://www.huertatipografica.com/free_download/23 -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="otf"
