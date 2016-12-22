# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic fortran-2 java-pkg-opt-2 pax-utils toolchain-funcs

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="http://www.octave.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0/${PV}"
IUSE="curl doc fftw +glpk gnuplot graphicsmagick hdf5 +imagemagick java opengl openssl
	portaudio postscript +qhull +qrupdate qt5 readline sndfile +sparse static-libs X zlib"
REQUIRED_USE="?? ( graphicsmagick imagemagick )"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	app-arch/bzip2
	app-text/ghostscript-gpl
	dev-libs/libpcre:3=
	sys-libs/ncurses:0=
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	curl? ( net-misc/curl:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:0= )
	gnuplot? ( sci-visualization/gnuplot )
	hdf5? ( sci-libs/hdf5:0= )
	graphicsmagick? ( media-gfx/graphicsmagick:=[cxx] )
	imagemagick? ( media-gfx/imagemagick:=[cxx] )
	java? ( >=virtual/jre-1.6.0:* )
	opengl? (
		media-libs/freetype:2=
		media-libs/fontconfig:1.0=
		>=x11-libs/fltk-1.3:1=[opengl,xft]
		x11-libs/gl2ps:0=
		virtual/glu )
	openssl? ( dev-libs/openssl:0= )
	portaudio? ( media-libs/portaudio )
	postscript? (
		app-text/epstool
		media-gfx/pstoedit
		media-gfx/transfig )
	qhull? ( media-libs/qhull:0= )
	qrupdate? ( sci-libs/qrupdate:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		>=x11-libs/qscintilla-2.9.3-r2:=[qt5(+)]
	)
	readline? ( sys-libs/readline:0= )
	sndfile? ( media-libs/libsndfile )
	sparse? (
		sci-libs/arpack:0=
		sci-libs/camd:0=
		sci-libs/ccolamd:0=
		sci-libs/cholmod:0=
		sci-libs/colamd:0=
		sci-libs/cxsparse:0=
		sci-libs/umfpack:0= )
	X? ( x11-libs/libX11:0= )"

DEPEND="${RDEPEND}
	qrupdate? ( app-misc/pax-utils )
	sparse? ( app-misc/pax-utils )
	java? ( >=virtual/jdk-1.6.0 )
	doc? (
		virtual/latex-base
		dev-texlive/texlive-genericrecommended
		dev-texlive/texlive-metapost )
	sys-apps/texinfo
	dev-util/gperf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.0-texi.patch
	"${FILESDIR}"/${PN}-4.2.0-disable-getcwd-path-max-test-as-it-is-too-slow.patch
	"${FILESDIR}"/${PN}-4.2.0-imagemagick-configure.patch
	"${FILESDIR}"/${PN}-4.2.0-imagemagick.patch
	"${FILESDIR}"/${PN}-4.2.0-pkgbuilddir.patch
	"${FILESDIR}"/${PN}-4.2.0-ncurses-pkgconfig.patch
	"${FILESDIR}"/${PN}-4.2.0-zlib-underlinking.patch
)

src_prepare() {
	# nasty prefix hacks for fltk:1 and qt4 linking
	if use prefix; then
		use opengl && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/fltk-1"
	fi

	# occasional fail on install, force regeneration (bug #401189)
	rm doc/interpreter/contributors.texi || die

	default
	eautoreconf
}

src_configure() {
	# [QA] detect underlinking #593670
	append-ldflags $(test-flags-CXX -Wl,-z,defs)

	# unfortunate dependency on mpi from hdf5 (bug #302621)
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc FC=mpif77 F77=mpif77

	local myconf=()
	if use graphicsmagick; then
		myconf+=( --with-magick=GraphicsMagick )
	elif use imagemagick; then
		myconf+=( --with-magick=ImageMagick )
	else
		myconf+=( --without-magick )
	fi

	econf "${myconf[@]}" \
		--localstatedir="${EPREFIX}/var/state/octave" \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		--disable-64 \
		--disable-jit \
		--enable-shared \
		--with-z \
		--with-bz2 \
		--without-OSMesa \
		$(use_enable static-libs static) \
		$(use_enable doc docs) \
		$(use_enable java) \
		$(use_enable readline) \
		$(use_with curl) \
		$(use_with fftw fftw3) \
		$(use_with fftw fftw3f) \
		$(use_enable fftw fftw-threads) \
		$(use_with glpk) \
		$(use_with hdf5) \
		$(use_with opengl) \
		$(use_with opengl fltk) \
		$(use_with openssl) \
		$(use_with portaudio) \
		$(use_with qhull) \
		$(use_with qrupdate) \
		$(use_with qt5 qt 5) \
		$(use_with sndfile) \
		$(use_with sparse arpack) \
		$(use_with sparse umfpack) \
		$(use_with sparse colamd) \
		$(use_with sparse ccolamd) \
		$(use_with sparse cholmod) \
		$(use_with sparse cxsparse) \
		$(use_with X x)
}

src_compile() {
	default
	if use java; then
		pax-mark m "${S}/src/.libs/octave-cli"
	fi
}

src_install() {
	default
	if use doc; then
		dodoc $(find doc -name '*.pdf')
	else
		# bug 566134, macros.texi is installed by make install if use doc
		insinto /usr/share/${PN}/${PV}/etc
		doins doc/interpreter/macros.texi
	fi
	[[ -e test/fntests.log ]] && dodoc test/fntests.log
	use java && \
		java-pkg_regjar "${ED%/}/usr/share/${PN}/${PV}/m/java/octave.jar"
	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${PN}/${PV}" > 99octave || die
	doenvd 99octave
}
