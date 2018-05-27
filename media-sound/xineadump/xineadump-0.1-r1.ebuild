# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Utility for Xine decoding support in transKode"
HOMEPAGE="https://sourceforge.net/projects/transkode"
SRC_URI="mirror://sourceforge/transkode/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/xine-lib
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.3.patch"
	"${FILESDIR}/${P}-gcc-4.4.patch"
)
