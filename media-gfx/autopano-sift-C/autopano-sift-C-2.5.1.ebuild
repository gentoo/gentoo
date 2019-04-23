# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="SIFT algorithm for automatic panorama creation in C"
HOMEPAGE="http://hugin.sourceforge.net/ http://user.cs.tu-berlin.de/~nowozin/autopano-sift/"
SRC_URI="mirror://sourceforge/hugin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-libs/libxml2
	media-libs/libpano13:0=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib
	virtual/jpeg:0"
RDEPEND="${DEPEND}
	!media-gfx/autopano-sift
"

PATCHES=( "${FILESDIR}"/${P}-lm.patch )
