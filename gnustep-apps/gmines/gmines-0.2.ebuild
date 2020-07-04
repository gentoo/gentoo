# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit gnustep-2

DESCRIPTION="The well-known minesweeper game"
HOMEPAGE="http://gap.nongnu.org/gmines/index.html"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/gm/GM}.tar.gz"
KEYWORDS="amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S=${WORKDIR}/${P/gm/GM}
