# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Socket Graphics tool for displaying polygons"
HOMEPAGE="http://fetk.org/codes/sg/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/maloc
	media-libs/mesa[X(+)]
	virtual/glu
	x11-libs/libGLw
	x11-libs/libXaw
	x11-libs/motif"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/1.4-opengl.patch
	"${FILESDIR}"/1.4-doc.patch
	"${FILESDIR}"/1.4-AC_CONFIG_HEADERS.patch
)

src_prepare() {
	default
	rm -r src/{gl,glu,glw} || die

	eautoreconf
}

src_configure() {
	local sg_include="${EPREFIX}"/usr/include
	local sg_lib="${EPREFIX}"/usr/$(get_libdir)

	export FETK_LIBRARY="${sg_lib}"
	export FETK_MOTIF_LIBRARY="${sg_lib}"
	export FETK_GL_LIBRARY="${sg_lib}"
	export FETK_GLU_LIBRARY="${sg_lib}"
	export FETK_GLW_LIBRARY="${sg_lib}"
	export FETK_INCLUDE="${sg_include}"
	export FETK_GLW_INCLUDE="${sg_include}"
	export FETK_GLU_INCLUDE="${sg_include}"
	export FETK_GL_INCLUDE="${sg_include}"/GL
	export FETK_MOTIF_INCLUDE="${sg_include}"

	econf \
		--disable-static \
		--disable-triplet \
		--enable-glforce \
		--enable-gluforce \
		--enable-glwforce \
		--with-doxygen=$(usex doc "${BROOT}"/usr/bin/doxygen "") \
		--with-dot=$(usex doc "${BROOT}"/usr/bin/dot "")
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
