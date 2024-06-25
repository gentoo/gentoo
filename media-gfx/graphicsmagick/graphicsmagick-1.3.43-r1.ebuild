# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_P=${P/graphicsm/GraphicsM}
DESCRIPTION="Collection of tools and libraries for many image formats"
HOMEPAGE="http://www.graphicsmagick.org/ https://foss.heptapod.net/graphicsmagick/graphicsmagick"

if [[ ${PV} == 9999 ]] ; then
	EHG_REPO_URI="https://foss.heptapod.net/${PN}/${PN}"
	inherit mercurial
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/bobfriesenhahn.asc
	inherit verify-sig

	SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}-history/$(ver_cut 1-2)/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://downloads.sourceforge.net/project/${PN}/${PN}-history/$(ver_cut 1-2)/${MY_P}.tar.xz.asc )"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-bobfriesenhahn )"
fi

LICENSE="MIT"
SLOT="0/${PV%.*}"
IUSE="bzip2 +cxx debug dynamic-loading fpx heif imagemagick jbig jpeg jpeg2k jpegxl lcms lzma"
IUSE+=" openmp perl png postscript q16 q32 static-libs tcmalloc tiff truetype"
IUSE+=" webp wmf X zlib zstd"

RDEPEND="
	dev-libs/libltdl
	bzip2? ( app-arch/bzip2 )
	fpx? ( media-libs/libfpx )
	heif? ( media-libs/libheif:= )
	imagemagick? ( !media-gfx/imagemagick )
	jbig? ( media-libs/jbigkit )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/jasper:= )
	jpegxl? ( media-libs/libjxl:= )
	lcms? ( media-libs/lcms:2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:= )
	postscript? ( app-text/ghostscript-gpl )
	tcmalloc? ( dev-util/google-perftools:= )
	tiff? ( media-libs/tiff:= )
	truetype? (
		media-fonts/urw-fonts
		>=media-libs/freetype-2
	)
	webp? ( media-libs/libwebp:= )
	wmf? ( media-libs/libwmf )
	X? (
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
	)
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}"
BDEPEND+=" virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.41-flags.patch
	"${FILESDIR}"/${PN}-1.3.41-perl.patch
	"${FILESDIR}"/${PN}-1.3.43-bashism.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local depth=8

	use q16 && depth=16
	use q32 && depth=32

	local myeconfargs=(
		--enable-largefile
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable debug prof)
		$(use_enable debug gcov)
		$(use_enable imagemagick magick-compat)
		$(use_enable openmp)
		--with-threads
		$(use_with dynamic-loading modules)
		--with-quantum-depth=${depth}
		--without-frozenpaths
		$(use_with cxx magick-plus-plus)
		$(use_with heif)
		$(use_with jpegxl jxl)
		$(use_with perl)
		--with-perl-options=INSTALLDIRS=vendor
		$(use_with bzip2 bzlib)
		$(use_with postscript dps)
		$(use_with fpx)
		$(use_with jbig)
		$(use_with webp)
		$(use_with jpeg)
		$(use_with jpeg2k jp2)
		$(use_with lcms lcms2)
		$(use_with lzma)
		$(use_with png)
		$(use_with tcmalloc)
		$(use_with tiff)
		--without-trio
		$(use_with truetype ttf)
		$(use_with wmf)
		--with-fontpath="${EPREFIX}"/usr/share/fonts
		--with-gs-font-dir="${EPREFIX}"/usr/share/fonts/urw-fonts
		--with-windows-font-dir="${EPREFIX}"/usr/share/fonts/corefonts
		$(use_with zlib)
		$(use_with zstd)
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	use perl && emake perl-build
}

src_test() {
	# Some perl tests fail when DISPLAY is set
	unset DISPLAY

	default
}

src_install() {
	default

	if use perl ; then
		emake -C PerlMagick DESTDIR="${D}" install

		find "${ED}" -type f -name perllocal.pod -exec rm -f {} + || die
		find "${ED}" -depth -mindepth 1 -type d -empty -exec rm -rf {} + || die
	fi

	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} + || die
}
