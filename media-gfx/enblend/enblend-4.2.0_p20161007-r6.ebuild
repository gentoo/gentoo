# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="cpu_flags_x86_sse2 debug doc openmp tcmalloc"

REQUIRED_USE="tcmalloc? ( !debug )"

BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
	doc? (
		app-text/ghostscript-gpl
		app-text/texlive
		dev-lang/perl
		dev-perl/Readonly
		dev-tex/hevea
		gnome-base/librsvg
		media-gfx/graphviz
		>=media-gfx/fig2dev-3.2.9-r1
		sci-visualization/gnuplot[cairo,gd]
		virtual/imagemagick-tools[tiff]
	)
"
RDEPEND="
	media-libs/lcms:2
	media-libs/tiff:=
	media-libs/vigra[openexr]
	sci-libs/gsl:=
	debug? ( dev-libs/dmalloc[threads] )
	tcmalloc? ( dev-util/google-perftools )
"
DEPEND="${RDEPEND}
	dev-libs/boost
	media-libs/libpng:0
	media-libs/libjpeg-turbo:=
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2-doc-install-dir-fix.patch
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-doc-scaleable-fonts.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e "s:share/doc/enblend:share/doc/${PF}:" doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)
		-DENABLE_DMALLOC=$(usex debug)
		-DDOC=$(usex doc)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_TCMALLOC=$(usex tcmalloc)
	)
	if use doc; then
		mycmakeargs+=(
			-DINSTALL_HTML_DOC=ON
			-DINSTALL_PDF_DOC=ON
		)
	fi

	cmake_src_configure
}

src_compile() {
	# To allow icon resizing with renderers (no way to disable)
	addpredict /dev/dri

	# To compile fonts in the temp directory
	export VARTEXFONTS="${T}/fonts"

	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	cmake_src_compile -j1
}
