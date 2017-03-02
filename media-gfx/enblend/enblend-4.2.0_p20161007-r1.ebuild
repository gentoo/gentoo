# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz"

LICENSE="GPL-2 VIGRA"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc openmp tcmalloc cpu_flags_x86_sse2"

REQUIRED_USE="tcmalloc? ( !debug )"

RDEPEND="
	media-libs/lcms:2
	media-libs/openexr:=
	media-libs/tiff:0
	media-libs/vigra[openexr]
	sci-libs/gsl:=
	debug? ( dev-libs/dmalloc )
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.62.0
	media-libs/libpng:0
	sys-apps/help2man
	virtual/jpeg:0
	virtual/pkgconfig
	doc? (
		dev-lang/perl
		dev-perl/Readonly
		dev-tex/hevea
		gnome-base/librsvg
		media-gfx/graphviz
		media-gfx/transfig
		sci-visualization/gnuplot[gd]
		virtual/imagemagick-tools
		virtual/latex-base
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2-doc-install-dir-fix.patch
	"${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e "s:share/doc/enblend:share/doc/${PF}:" doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DMALLOC=$(usex debug)
		-DENABLE_TCMALLOC=$(usex tcmalloc)
		-DDOC=$(usex doc)
		-DINSTALL_HTML_DOC=$(usex doc)
		-DINSTALL_PDF_DOC=$(usex doc)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)
	)
	cmake-utils_src_configure
}

src_compile() {
	# To allow icon resizing with renderers (no way to disable)
	addpredict /dev/dri

	# To compile fonts in the temp directory
	export VARTEXFONTS="${T}/fonts"

	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	cmake-utils_src_compile -j1
}
