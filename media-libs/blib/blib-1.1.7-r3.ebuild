# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library full of useful things to hack the Blinkenlights"
HOMEPAGE="http://www.blinkenlights.de"
SRC_URI="http://www.blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aalib gtk"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	aalib? ( media-libs/aalib )
	gtk? (
		app-accessibility/at-spi2-core:2
		media-libs/fontconfig
		media-libs/freetype
		media-libs/harfbuzz:=
		x11-libs/cairo
		x11-libs/gtk+:2
		x11-libs/pango
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-deprecated.patch
)

src_prepare() {
	default

	# drop DEPRECATED flags, bug #391105
	sed -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		-i {blib,gfx,{,test/}modules}/Makefile.{am,in} || die
}

src_configure() {
	local econfargs=(
		$(use_enable aalib aa)
		--disable-directfb
		$(use_enable gtk)
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
