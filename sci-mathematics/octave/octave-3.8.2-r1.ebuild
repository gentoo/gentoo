# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils multilib toolchain-funcs fortran-2 flag-o-matic java-pkg-opt-2 pax-utils

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="http://www.octave.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

SLOT="0/${PV}"
IUSE="curl doc fftw +glpk gnuplot graphicsmagick gui hdf5 +imagemagick java opengl
	postscript +qhull +qrupdate readline +sparse static-libs X zlib"
REQUIRED_USE="?? ( graphicsmagick imagemagick )"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	dev-libs/libpcre:3=
	sys-libs/ncurses:0=
	virtual/lapack
	curl? ( net-misc/curl:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:0= )
	gnuplot? ( sci-visualization/gnuplot )
	gui? ( x11-libs/qscintilla:0= )
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
	postscript? (
		app-text/epstool
		media-gfx/pstoedit
		media-gfx/transfig )
	qhull? ( media-libs/qhull:0= )
	qrupdate? ( sci-libs/qrupdate:0= )
	readline? ( sys-libs/readline:0= )
	sparse? (
		sci-libs/arpack:0=
		sci-libs/camd:0=
		sci-libs/ccolamd:0=
		sci-libs/cholmod:0=
		sci-libs/colamd:0=
		sci-libs/cxsparse:0=
		sci-libs/umfpack:0= )
	X? ( x11-libs/libX11:0= )
	zlib? ( sys-libs/zlib:0= )"

DEPEND="${RDEPEND}
	qrupdate? ( app-misc/pax-utils )
	sparse? ( app-misc/pax-utils )
	java? ( >=virtual/jdk-1.6.0 )
	doc? (
		virtual/latex-base
		dev-texlive/texlive-genericrecommended
		dev-texlive/texlive-metapost
		sys-apps/texinfo )
	dev-util/gperf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.3-texi.patch
	"${FILESDIR}"/${PN}-3.8.0-disable-getcwd-path-max-test-as-it-is-too-slow.patch
	"${FILESDIR}"/${PN}-3.8.0-imagemagick-configure.patch
	"${FILESDIR}"/${PN}-3.8.1-imagemagick.patch
	"${FILESDIR}"/${PN}-3.8.1-pkgbuilddir.patch
)

src_prepare() {
	# nasty prefix hacks for fltk:1 and qt4 linking
	if use prefix; then
		use opengl && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/fltk-1"
		use gui && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/qt4"
	fi

	# Fix bug 501756
	sed -i \
		-e 's@A-Za-z0-9@[:alnum:]@g' \
		-e 's@A-Za-z@[:alpha:]@g' \
		libinterp/mkbuiltins || die
	autotools-utils_src_prepare
}

src_configure() {
	# occasional fail on install, force regeneration (bug #401189)
	rm doc/interpreter/contributors.texi || die

	# unfortunate dependency on mpi from hdf5 (bug #302621)
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc FC=mpif77 F77=mpif77

	local myeconfargs=(
		--localstatedir="${EPREFIX}/var/state/octave"
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		$(use_enable doc docs)
		$(use_enable java)
		$(use_enable gui)
		# requires llvm < 3.5
		--disable-jit
		$(use_enable readline)
		$(use_with curl)
		$(use_with fftw fftw3)
		$(use_with fftw fftw3f)
		$(use_enable fftw fftw-threads)
		$(use_with glpk)
		$(use_with hdf5)
		$(use_with opengl)
		$(use_with qhull)
		$(use_with qrupdate)
		$(use_with sparse arpack)
		$(use_with sparse umfpack)
		$(use_with sparse colamd)
		$(use_with sparse ccolamd)
		$(use_with sparse cholmod)
		$(use_with sparse cxsparse)
		$(use_with X x)
		$(use_with zlib z)
	)
	if use graphicsmagick; then
		myeconfargs+=( "--with-magick=GraphicsMagick" )
	elif use imagemagick; then
		myeconfargs+=( "--with-magick=ImageMagick" )
	else
		myeconfargs+=( "--without-magick" )
	fi
	autotools-utils_src_configure
}

src_compile() {
	emake
	if use java ; then
		pax-mark m "${S}/src/.libs/octave-cli"
	fi
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc $(find doc -name \*.pdf)
	[[ -e test/fntests.log ]] && dodoc test/fntests.log
	use java && \
		java-pkg_regjar "${ED}/usr/share/${PN}/${PV}/m/java/octave.jar"
	echo "LDPATH=${EROOT}usr/$(get_libdir)/${PN}/${PV}" > 99octave
	doenvd 99octave
}
