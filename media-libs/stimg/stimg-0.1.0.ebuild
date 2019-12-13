# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple and tiny image loading library"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/"
SRC_URI="http://homepage3.nifty.com/slokar/stimg/${P}.tar.gz"

LICENSE="LGPL-2+ MIT-with-advertising"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

RDEPEND="
	media-libs/libpng:=
	media-libs/tiff:=
	virtual/jpeg"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-libpng15.patch )

src_configure() {
	tc-export CC
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
