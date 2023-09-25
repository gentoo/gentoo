# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="An audio player, primarily for the console"
HOMEPAGE="https://splay.sourceforge.net/"
SRC_URI="https://splay.sourceforge.net/tgz/${P}.tar.gz"

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

src_configure() {
	append-cxxflags -std=c++14

	default
}
