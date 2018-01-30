# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Simple and tiny image loading library"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/"
SRC_URI="http://homepage3.nifty.com/slokar/stimg/${P}.tar.gz"

LICENSE="LGPL-2+ MIT-with-advertising"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="static-libs"

RDEPEND="media-libs/libpng
	media-libs/tiff
	virtual/jpeg"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS )

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch
}

src_configure() {
	tc-export CC
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} +
	dodoc README.ja
}
