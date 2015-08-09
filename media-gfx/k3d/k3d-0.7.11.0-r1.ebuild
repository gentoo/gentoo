# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cmake-utils flag-o-matic

MY_P="${PN}-source-${PV}"

DESCRIPTION="A free 3D modeling, animation, and rendering system"
HOMEPAGE="http://www.k-3d.org/"
SRC_URI="mirror://sourceforge/k3d/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="3ds cuda gnome graphviz gts imagemagick jpeg nls openexr png python tiff truetype" #TODO cgal tbb

RDEPEND="
	dev-libs/boost[python]
	>=dev-cpp/glibmm-2.6:2
	>=dev-cpp/gtkmm-2.6:2.4
	dev-libs/expat
	>=dev-libs/libsigc++-2.2:2
	media-libs/mesa
	virtual/glu
	virtual/opengl
	>=x11-libs/gtkglext-1.0.6-r3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXmu
	x11-libs/libXt
	3ds? ( media-libs/lib3ds )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	gnome? ( gnome-base/libgnome )
	graphviz? ( media-gfx/graphviz )
	gts? ( sci-libs/gts )
	imagemagick? ( media-gfx/imagemagick )
	jpeg? ( virtual/jpeg )
	openexr? ( media-libs/openexr )
	png? ( >=media-libs/libpng-1.2.43-r2 )
	python? ( >=dev-lang/python-2.3 dev-python/cgkit )
	tiff? ( media-libs/tiff )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS README"

# k3d_use_enable()
#
# $1: use flag. ON|OFF is determined by this.
# $2: part of cmake variable name which appended to the base variable name
#     that is -DK3D_BUILD_$2
#
# e.g.) k3d_use_enable gnome GNOME_MODULE #=> -DK3D_BUILD_GNOME_MODULE=ON
#
k3d_use_enable() {
	echo "-DK3D_BUILD_$2=$(use $1 && echo ON || echo OFF)"
}

k3d_use_module() {
	echo "-DK3D_BUILD_$2_MODULE=$(use $1 && echo ON || echo OFF)"
}

src_prepare() {
	sed -i \
		-e '/PKG_CHECK_MODULES/s:libpng12:libpng:' \
		cmake/modules/K3DFindPNG.cmake || die

	epatch "${FILESDIR}"/${P}-libpng14.patch

	epatch "${FILESDIR}"/${P}-fix-potfiles.patch \
		"${FILESDIR}"/${P}-cuda.patch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gtk-liststore-vs-treemodel.patch \
		"${FILESDIR}"/${P}-gcc47.patch

	[[ -f CMakeCache.txt ]] && rm CMakeCache.txt
}

src_configure() {
	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	mycmakeargs="
		-DK3D_BUILD_SVG_IO_MODULE=ON
		-DK3D_BUILD_CGAL_MODULE=OFF
		$(k3d_use_module 3ds 3DS_IO)
		$(k3d_use_module cuda CUDA)
		$(k3d_use_module gnome GNOME)
		$(k3d_use_module graphviz GRAPHVIZ)
		$(k3d_use_module gts GTS)
		$(k3d_use_module gts GTS_IO)
		$(k3d_use_module imagemagick IMAGEMAGICK_IO)
		$(k3d_use_module jpeg JPEG_IO)
		$(k3d_use_enable nls NLS)
		$(k3d_use_module openexr OPENEXR_IO)
		$(k3d_use_module png PNG_IO)
		$(k3d_use_module python PYTHON)
		$(k3d_use_module python PYUI)
		$(k3d_use_module python NGUI_PYTHON_SHELL)
		$(k3d_use_module tiff TIFF_IO)
		$(k3d_use_module truetype FREETYPE2)"

	cmake-utils_src_configure
}
