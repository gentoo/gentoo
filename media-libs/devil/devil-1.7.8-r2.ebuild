# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_P=DevIL-${PV}

DESCRIPTION="DevIL image library"
HOMEPAGE="http://openil.sourceforge.net/"
SRC_URI="mirror://sourceforge/openil/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86"
IUSE="allegro gif glut jpeg jpeg2k mng nvtt openexr opengl png sdl cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 static-libs tiff xpm X"

RDEPEND="allegro? ( media-libs/allegro:0 )
	gif? ( media-libs/giflib:= )
	glut? ( media-libs/freeglut )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/jasper )
	mng? ( media-libs/libmng:= )
	nvtt? ( media-gfx/nvidia-texture-tools )
	openexr? ( media-libs/openexr:= )
	opengl? ( virtual/opengl
		virtual/glu )
	png? ( media-libs/libpng:0= )
	sdl? ( media-libs/libsdl )
	tiff? ( media-libs/tiff:0 )
	xpm? ( x11-libs/libXpm )
	X? ( x11-libs/libXext
		 x11-libs/libX11
		 x11-libs/libXrender )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-proto/xextproto )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{CVE-2009-3994,libpng14,nvtt-glut,ILUT,restrict,fix-test}.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-lcms \
		--enable-ILU \
		--enable-ILUT \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable openexr exr) \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable jpeg2k jp2) \
		$(use_enable mng) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_enable xpm) \
		$(use_enable allegro) \
		--disable-directx8 \
		--disable-directx9 \
		$(use_enable opengl) \
		$(use_enable sdl) \
		$(use_enable X x11) \
		$(use_enable X shm) \
		$(use_enable X render) \
		$(use_enable glut) \
		$(use_with X x) \
		$(use_with nvtt)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
