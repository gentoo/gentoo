# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_P=DevIL-${PV}

DESCRIPTION="DevIL image library"
HOMEPAGE="https://openil.sourceforge.net/"
SRC_URI="mirror://sourceforge/openil/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv x86"
IUSE="allegro cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 gif glut jpeg mng opengl png sdl static-libs tiff X xpm"

# OpenEXR support dropped b/c no support for OpenEXR 3
# See bug #833833
RDEPEND="
	allegro? ( media-libs/allegro:0 )
	gif? ( media-libs/giflib:= )
	glut? ( media-libs/freeglut )
	jpeg? ( media-libs/libjpeg-turbo:= )
	mng? ( media-libs/libmng:= )
	opengl? (
		virtual/opengl
		virtual/glu
	)
	png? ( media-libs/libpng:= )
	sdl? ( media-libs/libsdl )
	tiff? ( media-libs/tiff:= )
	X? (
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXrender
	)
	xpm? ( x11-libs/libXpm )"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

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
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859835
	# https://github.com/DentonW/DevIL/issues/110
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	econf \
		$(use_enable static-libs static) \
		--disable-lcms \
		--enable-ILU \
		--enable-ILUT \
		$(use_enable cpu_flags_x86_sse sse) \
		$(use_enable cpu_flags_x86_sse2 sse2) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		--disable-exr \
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
		--without-nvtt
}

src_install() {
	default

	# Package provides .pc files
	find "${ED}" -name '*.la' -delete || die
}
