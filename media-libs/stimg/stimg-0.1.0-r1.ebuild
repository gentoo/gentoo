# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Simple and tiny image loading library"
HOMEPAGE="http://homepage3.nifty.com/slokar/fb/"
SRC_URI="http://homepage3.nifty.com/slokar/stimg/${P}.tar.gz"

LICENSE="LGPL-2+ MIT-with-advertising"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"

RDEPEND="
	media-libs/libpng:=
	media-libs/libjpeg-turbo:=
	media-libs/tiff:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-libpng15.patch
)

src_prepare() {
	default

	# bug #871486
	eautoreconf
}

src_configure() {
	tc-export CC

	default
}

src_install() {
	default

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}
