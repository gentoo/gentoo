# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Development Library for making games for X"
HOMEPAGE="http://kxl.orz.hm/"
SRC_URI="http://kxl.hn.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-m4.patch
	"${FILESDIR}"/${P}-amd64.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
