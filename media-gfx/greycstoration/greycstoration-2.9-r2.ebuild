# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Image regularization algorithm for denoising, inpainting and resizing"
HOMEPAGE="http://www.greyc.ensicaen.fr/~dtschump/greycstoration/"
SRC_URI="mirror://sourceforge/cimg/GREYCstoration-${PV}.zip"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fftw imagemagick jpeg lapack png tiff"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	fftw? ( >=sci-libs/fftw-3:3.0= )
	imagemagick? ( media-gfx/imagemagick:0= )
	jpeg? ( virtual/jpeg:0 )
	lapack? ( virtual/lapack )
	png? ( >=media-libs/libpng-1.4:0= )
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	fftw? ( virtual/pkgconfig )
	lapack? ( virtual/pkgconfig )
	png? ( virtual/pkgconfig )
"

S="${WORKDIR}/GREYCstoration-${PV}/src"

PATCHES=(
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:../CImg.h:CImg.h:" \
		greycstoration.cpp || die
}

src_compile() {
	local myconf="-Dcimg_use_xshm -Dcimg_use_xrandr -lX11 -lXext -lXrandr"

	use png && myconf+=" -Dcimg_use_png $($(tc-getPKG_CONFIG) --libs libpng) -lz"
	use jpeg && myconf+=" -Dcimg_use_jpeg -ljpeg"
	use tiff && myconf+=" -Dcimg_use_tiff -ltiff"
	use imagemagick && \
		myconf+=" -Dcimg_use_magick $(Magick++-config --cppflags) $(Magick++-config --libs)"
	use fftw && myconf+=" -Dcimg_use_fftw3 $($(tc-getPKG_CONFIG) --libs fftw3)"
	use lapack && myconf+=" -Dcimg_use_lapack $($(tc-getPKG_CONFIG) --libs lapack)"

	_cmd="$(tc-getCXX) ${LDFLAGS} ${CXXFLAGS} -fno-tree-pre \
		-o greycstoration greycstoration.cpp \
		${myconf} -lm -lpthread"
	einfo "${_cmd}"
	eval ${_cmd} || die
}

src_install() {
	dobin greycstoration
}
