# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P=DevIL-${PV}

DESCRIPTION="DevIL image library"
HOMEPAGE="http://openil.sourceforge.net/"
SRC_URI="mirror://sourceforge/openil/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~mips ppc ppc64 x86"
IUSE="allegro cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 gif glut jpeg mng nvtt openexr opengl png sdl static-libs tiff X xpm"

RDEPEND="
	allegro? ( media-libs/allegro:0 )
	gif? ( media-libs/giflib:= )
	glut? ( media-libs/freeglut )
	jpeg? ( virtual/jpeg:0 )
	mng? ( media-libs/libmng:= )
	nvtt? ( media-gfx/nvidia-texture-tools )
	openexr? ( media-libs/openexr:= )
	opengl? ( virtual/opengl
		virtual/glu )
	png? ( media-libs/libpng:0= )
	sdl? ( media-libs/libsdl )
	tiff? ( media-libs/tiff:0 )
	X? ( x11-libs/libXext
		 x11-libs/libX11
		 x11-libs/libXrender )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}/${P}"-CVE-2009-3994.patch
	"${FILESDIR}/${P}"-libpng14.patch
	"${FILESDIR}/${P}"-nvtt-glut.patch
	"${FILESDIR}/${P}"-ILUT.patch
	"${FILESDIR}/${P}"-restrict.patch
	"${FILESDIR}/${P}"-fix-test.patch
	"${FILESDIR}/${P}"-jasper-remove-uchar.patch
)

src_prepare() {
	default
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
		--enable-jp2 \
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

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
