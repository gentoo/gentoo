# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A cuddly teddy bear (or other image) for your X desktop"
HOMEPAGE="http://webstaff.itn.liu.se/~stegu/xteddy/"
SRC_URI="http://webstaff.itn.liu.se/~stegu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-libs/imlib2[X,png]
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS README ChangeLog NEWS xteddy.README )

PATCHES=(
	"${FILESDIR}"/${P}-linking.patch
)

src_prepare() {
	default
	# Fix paths in xtoys script wrt bug #404899
	sed -i -e "s:/usr/games:/usr/bin:" xtoys || die
	eautoreconf
}
