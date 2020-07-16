# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="An audio player, primarily for the console"
HOMEPAGE="http://splay.sourceforge.net/"
SRC_URI="http://splay.sourceforge.net/tgz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-libs/id3lib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-external-id3lib.diff
	"${FILESDIR}"/${P}-gcc43-2.patch
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}
