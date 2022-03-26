# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library of cd audio related routines"
HOMEPAGE="http://libcdaudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ppc ~ppc64 sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.99-CAN-2005-0706.patch
	"${FILESDIR}"/${P}-bug245649.patch
	"${FILESDIR}"/${P}-libdir-fix.patch
)

src_configure() {
	econf --enable-threads --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
