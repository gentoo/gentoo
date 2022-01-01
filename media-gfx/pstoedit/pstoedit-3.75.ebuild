# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Translate PostScript and PDF graphics into other vector formats"
HOMEPAGE="https://sourceforge.net/projects/pstoedit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="emf imagemagick plotutils pptx"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	>=app-text/ghostscript-gpl-8.71-r1
	>=media-libs/gd-2.0.35-r1:=
	emf? ( >=media-libs/libemf-1.0.3 )
	imagemagick? ( >=media-gfx/imagemagick-6.6.1.2:=[cxx] )
	plotutils? ( media-libs/plotutils )
	pptx? ( dev-libs/libzip:= )
"
DEPEND="${RDEPEND}"

DOCS=( doc/readme.txt )
HTML_DOCS=( doc/{changelog,pstoedit}.htm )

PATCHES=( "${FILESDIR}"/${P}-libdl.patch )

src_prepare() {
	default

	sed -i \
		-e '/CXXFLAGS="-g"/d' \
		-e 's:-pedantic::' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--without-swf
		$(use_with emf)
		$(use_with imagemagick magick)
		$(use_with plotutils libplot)
		$(use_with pptx)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman doc/pstoedit.1

	find "${ED}" -name '*.la' -delete || die
}
