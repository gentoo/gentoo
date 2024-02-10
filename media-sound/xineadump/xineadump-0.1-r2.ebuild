# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for Xine decoding support in transKode"
HOMEPAGE="https://sourceforge.net/projects/transkode"
SRC_URI="mirror://sourceforge/transkode/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	media-libs/xine-lib
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gcc-4.3.patch"
	"${FILESDIR}/${P}-gcc-4.4.patch"
)
