# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

EGIT_COMMIT="d086a618248121d61e3f3de64b4301230d1c860c"
DESCRIPTION="Modified version of Inconsolata Hellenic adding the Cyrillic alphabet"
HOMEPAGE="https://github.com/DeLaGuardo/Inconsolata-LGC"
SRC_URI="https://github.com/DeLaGuardo/Inconsolata-LGC/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

S="${WORKDIR}/DeLaGuardo-Inconsolata-LGC-${EGIT_COMMIT::7}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
