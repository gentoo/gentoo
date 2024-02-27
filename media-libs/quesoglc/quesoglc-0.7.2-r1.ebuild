# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free implementation of the OpenGL Character Renderer (GLC)"
HOMEPAGE="https://quesoglc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-free.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="doc"

RDEPEND="
	dev-libs/fribidi
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)"

src_prepare() {
	default
	rm -r src/fribidi || die
}

src_configure() {
	# Uses its own copy of media-libs/glew with GLEW_MX
	local myeconfargs=(
		--disable-executables
		--with-fribidi
		--without-glew
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake all $(usev doc)
}

src_install() {
	default

	use doc && dodoc -r docs/html
	find "${ED}" -name '*.la' -delete || die
}
