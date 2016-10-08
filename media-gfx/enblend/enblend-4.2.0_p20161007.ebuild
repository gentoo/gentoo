# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Image Blending with Multiresolution Splines"
HOMEPAGE="http://enblend.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~soap/distfiles/${P}.tar.xz"

LICENSE="GPL-2 VIGRA"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc openmp tcmalloc cpu_flags_x86_sse2"

REQUIRED_USE="
	html? ( doc )
	pdf? ( doc )
	tcmalloc? ( !debug )"

RDEPEND="
	>=dev-libs/boost-1.62.0:=
	media-libs/glew:*
	>=media-libs/lcms-2.5:2
	>=media-libs/libpng-1.2.43:0=
	>=media-libs/openexr-1.0:=
	media-libs/plotutils[X]
	media-libs/tiff:=
	>=media-libs/vigra-1.8.0[openexr]
	sci-libs/gsl:=
	virtual/jpeg:0=
	debug? ( dev-libs/dmalloc )
	tcmalloc? ( dev-util/google-perftools )
	media-libs/freeglut"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
	sys-apps/help2man
	virtual/pkgconfig
	doc? (
		media-gfx/transfig
		sci-visualization/gnuplot[gd]
		virtual/latex-base
		dev-lang/perl
		media-gfx/graphviz
		gnome-base/librsvg
		dev-tex/hevea
	)"

PATCHES=( "${FILESDIR}/${PN}-4.2-doc-install-dir-fix.patch" )

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e "s:share/doc/enblend:share/doc/${PF}:" doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DMALLOC=$(usex debug)
		-DENABLE_TCMALLOC=$(usex tcmalloc)
		-DDOC=$(usex doc)
		-DINSTALL_HTML_DOC=$(usex html)
		-DINSTALL_PDF_DOC=$(usex pdf)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2)
	)

	cmake-utils_src_configure
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	# forcing -j1 as every parallel compilation process needs about 1 GB RAM.
	cmake-utils_src_compile -j1
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	cmake-utils_src_install
}
