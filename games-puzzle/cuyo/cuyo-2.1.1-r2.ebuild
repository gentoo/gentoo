# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

# This version (2.~-1.1) should've been 2_pre11 or so, i.e. >=2.0.0 is newer.
# Optimally need upstream to release >=2.1.2, or will need own custom version.
MY_P="${PN}-$(ver_cut 1).~-$(ver_cut 2-3)"

DESCRIPTION="Highly addictive and remotely related to tetris"
HOMEPAGE="https://www.karimmi.de/cuyo/"
SRC_URI="https://savannah.nongnu.org/download/cuyo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer[mod]
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc6.patch
)
