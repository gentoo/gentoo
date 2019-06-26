# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib

DESCRIPTION="Socket Graphics tool for displaying polygons"
HOMEPAGE="http://fetk.org/codes/sg/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/maloc
	virtual/glu
	x11-libs/libXaw
	x11-libs/motif
	|| (
		( media-libs/mesa[X(+)] x11-libs/libGLw )
		media-libs/opengl-apple
		)"
DEPEND="
	${RDEPEND}
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
		)"

S="${WORKDIR}"/${PN}

PATCHES=(
	"${FILESDIR}"/1.4-opengl.patch
	"${FILESDIR}"/1.4-doc.patch
	)

src_prepare() {
	rm src/{gl,glu,glw} -rf || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local sg_include
	local sg_lib
	local myeconfargs

	sg_include="${EPREFIX}"/usr/include
	sg_lib="${EPREFIX}"/usr/$(get_libdir)
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

	use doc || myeconfargs+=( --with-doxygen= --with-dot= )

	myeconfargs+=( --enable-glforce --enable-gluforce --enable-glwforce )

	myeconfargs+=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		--disable-triplet
	)
	autotools-utils_src_configure
}
