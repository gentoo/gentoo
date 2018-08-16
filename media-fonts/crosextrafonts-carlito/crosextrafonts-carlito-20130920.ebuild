# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Open licensed sans-serif font metrically compatible with Calibri"
HOMEPAGE="http://code.google.com/p/chromium/issues/detail?id=280557"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip test"

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}"/62-crosextra-carlito.conf )
