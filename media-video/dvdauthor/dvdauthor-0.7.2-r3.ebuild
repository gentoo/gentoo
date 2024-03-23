# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Tools for generating DVD files to be played on standalone DVD players"
HOMEPAGE="https://dvdauthor.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="graphicsmagick +imagemagick"

RDEPEND=">=dev-libs/fribidi-0.19.2
	dev-libs/libxml2
	>=media-libs/freetype-2
	media-libs/libdvdread
	media-libs/libpng:0=
	imagemagick? (
		graphicsmagick? ( media-gfx/graphicsmagick:= )
		imagemagick? ( media-gfx/imagemagick:= )
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-freetype-pkgconfig.patch
)

src_prepare() {
	default

	eautoreconf

	if use imagemagick && has_version '>=media-gfx/imagemagick-7.0.1.0' ; then
		eapply "${FILESDIR}/${PN}-0.7.2-imagemagick7.patch"
	fi

	if use graphicsmagick ; then
		sed -i -e 's:ExportImagePixels:dIsAbLeAuToMaGiC&:' configure \
			|| die
	fi
}

src_configure() {
	use graphicsmagick && \
		append-cppflags "$($(tc-getPKG_CONFIG) --cflags GraphicsMagick)" #459976
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags fribidi)" #417041
	econf
}
