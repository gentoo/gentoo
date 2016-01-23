# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="An audio player, primarily for the console"
HOMEPAGE="http://splay.sourceforge.net/"
SRC_URI="http://splay.sourceforge.net/tgz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-external-id3lib.diff"
	"${FILESDIR}/${P}-gcc43-2.patch"
	"${FILESDIR}/${P}-modernize-cpp.patch"
)

src_prepare() {
	mv configure.{in,ac} || die
	default
	eautoreconf
}
