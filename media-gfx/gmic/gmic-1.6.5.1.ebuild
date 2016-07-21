# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs bash-completion-r1 flag-o-matic

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/"
SRC_URI="http://gmic.eu/files/source/${PN}_${PV}.tar.gz"

LICENSE="CeCILL-2 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg fftw graphicsmagick jpeg opencv openexr openmp png tiff X zlib"

DEPEND="
	fftw? ( sci-libs/fftw:3.0[threads] )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( >=media-libs/opencv-2.3.1a-r1 )
	openexr? (
		media-libs/ilmbase
		media-libs/openexr
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	ffmpeg? ( media-video/ffmpeg:0 )
"

S=${WORKDIR}/${P}/src

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	for i in fftw jpeg opencv openmp png tiff zlib ; do
		use $i || { sed -i -r "s/^(${i}_(CFLAGS|LIBS) =).*/\1/I" Makefile || die ; }
	done

	use graphicsmagick || { sed -i -r "s/^(MAGICK_(CFLAGS|LIBS) =).*/\1/" Makefile || die ; }
	use openexr || { sed -i -r "s/^(EXR_(CFLAGS|LIBS) =).*/\1/" Makefile || die ; }

	if ! use X ; then
		sed -i -r "s/^((X11|XSHM)_(CFLAGS|LIBS) =).*/\1/" Makefile || die

		# disable display capabilities when X support is disabled
		append-cxxflags -Dcimg_display=0
	fi
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" \
		LIB="$(get_libdir)" OPT_CFLAGS= DEBUG_CFLAGS= cli lib
	emake man bashcompletion
}

src_install() {
	emake DESTDIR="${D}" LIB="$(get_libdir)" install-bin install-lib install-man install-bash
	dodoc ../README
}
