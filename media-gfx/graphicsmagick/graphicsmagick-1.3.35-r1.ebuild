# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

MY_P=${P/graphicsm/GraphicsM}

DESCRIPTION="Collection of tools and libraries for many image formats"
HOMEPAGE="http://www.graphicsmagick.org/"
LICENSE="MIT"
SLOT="0/${PV%.*}"

if [[ ${PV} == "9999" ]] ; then
	inherit mercurial
	EHG_REPO_URI="http://hg.code.sf.net/p/${PN}/code"
else
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

IUSE="bzip2 +cxx debug dynamic-loading fpx imagemagick jbig jpeg lcms lzma
	openmp perl png postscript q16 q32 static-libs svg threads tiff truetype
	webp wmf X zlib"

RDEPEND="dev-libs/libltdl:0
	bzip2? ( app-arch/bzip2 )
	fpx? ( media-libs/libfpx )
	imagemagick? ( !media-gfx/imagemagick )
	jbig? ( media-libs/jbigkit )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	postscript? ( app-text/ghostscript-gpl )
	svg? ( dev-libs/libxml2 )
	tiff? ( media-libs/tiff:0 )
	truetype? (
		media-fonts/urw-fonts
		>=media-libs/freetype-2
		)
	webp? ( media-libs/libwebp:= )
	wmf? ( media-libs/libwmf )
	X? (
		x11-libs/libSM
		x11-libs/libXext
		)
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.19-flags.patch
	"${FILESDIR}"/${PN}-1.3.19-perl.patch
	"${FILESDIR}"/${P}-CVE-2020-12672.patch
	"${FILESDIR}"/${P}-oss-fuzz-20045-20318-21956.patch
	"${FILESDIR}"/${P}-oss-fuzz-23042.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local depth=8
	use q16 && depth=16
	use q32 && depth=32

	local openmp=disable
	if use openmp && tc-has-openmp; then
		openmp=enable
	fi

	local myeconfargs=(
		--${openmp}-openmp
		--enable-largefile
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable debug prof)
		$(use_enable debug gcov)
		$(use_enable imagemagick magick-compat)
		$(use_with threads)
		$(use_with dynamic-loading modules)
		--with-quantum-depth=${depth}
		--without-frozenpaths
		$(use_with cxx magick-plus-plus)
		$(use_with perl)
		--with-perl-options=INSTALLDIRS=vendor
		$(use_with bzip2 bzlib)
		$(use_with postscript dps)
		$(use_with fpx)
		$(use_with jbig)
		$(use_with webp)
		$(use_with jpeg)
		--without-jp2
		$(use_with lcms lcms2)
		$(use_with lzma)
		$(use_with png)
		$(use_with tiff)
		$(use_with truetype ttf)
		$(use_with wmf)
		--with-fontpath="${EPREFIX}"/usr/share/fonts
		--with-gs-font-dir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-windows-font-dir="${EPREFIX}"/usr/share/fonts/corefonts
		$(use_with svg xml)
		$(use_with zlib)
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use perl && emake perl-build
}

src_test() {
	unset DISPLAY # some perl tests fail when DISPLAY is set
	default
}

src_install() {
	default

	if use perl; then
		emake -C PerlMagick DESTDIR="${D}" install
		find "${ED}" -type f -name perllocal.pod -exec rm -f {} + || die
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} + || die
	fi

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} + || die
}
