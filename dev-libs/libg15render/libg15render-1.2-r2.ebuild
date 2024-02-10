# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Small library for display text and graphics on a Logitech G15 keyboard"
HOMEPAGE="https://sourceforge.net/projects/g15tools/"
SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="truetype"

RDEPEND="
	dev-libs/libg15
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}"
BDEPEND="
	truetype? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${P}-pixel-c.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype ttf)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -type f -name '*.la' -delete || die
}
