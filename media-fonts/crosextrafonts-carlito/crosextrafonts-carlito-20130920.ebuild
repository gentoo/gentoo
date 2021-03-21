# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Open licensed sans-serif font metrically compatible with Calibri"
HOMEPAGE="https://bugs.chromium.org/p/chromium/issues/detail?id=280557"
SRC_URI="https://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="binchecks strip test"

FONT_CONF=( "${FILESDIR}"/62-crosextra-carlito.conf )
FONT_SUFFIX="ttf"
