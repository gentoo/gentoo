# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

MY_P="LapisPuzzle-${PV}"

DESCRIPTION="a Tetris-like game where each player is effected by the others game play"
HOMEPAGE="http://gap.nongnu.org/lapispuzzle/"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"
