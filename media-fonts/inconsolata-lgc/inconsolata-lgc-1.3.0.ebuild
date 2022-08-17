# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Modified version of Inconsolata Hellenic adding the Cyrillic alphabet"
HOMEPAGE="https://github.com/MihailJP/Inconsolata-LGC"
SRC_URI="https://github.com/MihailJP/Inconsolata-LGC/archive/LGC-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv"

BDEPEND="media-gfx/fontforge"

S="${WORKDIR}/Inconsolata-LGC-LGC-${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
