# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="A humanist sans-serif typeface with a calligraphic, dynamic feeling"
HOMEPAGE="https://www.huertatipografica.com/en/fonts/alegreya-sans-ht"
SRC_URI="https://github.com/huertatipografica/Alegreya-Sans/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DOCS="CONTRIBUTORS.txt README.md"
S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"
