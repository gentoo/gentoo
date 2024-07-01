# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic fortran-2 java-pkg-opt-2 pax-utils qmake-utils toolchain-funcs xdg

DESCRIPTION="High-level interactive language for numerical computations"
HOMEPAGE="https://www.gnu.org/software/octave/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

IUSE="curl doc fftw fltk +glpk gnuplot gui hdf5 imagemagick java json klu opengl portaudio postscript +qhull +qrupdate +qt5 qt6 readline sndfile +sparse spqr ssl sundials X zlib"

# Although it is listed in INSTALL.OCTAVE as a build tool, Octave runs
# "makeinfo" from sys-apps/texinfo at runtime to convert its texinfo
# documentation to text (see scripts/help/help.m).
#
# (un)zip isn't mentioned, but there's a test that uses it (bug #775254).
#
# The use of USE=imagemagick to pull in media-gfx/graphicsmagick is not
# ideal, but both "graphicsmagick" and "imagemagick" are global USE
# flags whose existing descriptions conflict with the obvious way we
# would want to use them in octave. In any case, upstream doesn't really
# support imagemagick, only graphicsmagick (bug 864785).
COMMON_DEPS="
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	app-text/ghostscript-gpl
	sys-apps/texinfo
	dev-libs/libpcre2
	sys-libs/ncurses:=
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	curl? ( net-misc/curl:= )
	fftw? ( sci-libs/fftw:3.0= )
	fltk? ( >=x11-libs/fltk-1.3:1=[opengl,xft] )
	glpk? ( sci-mathematics/glpk:= )
	gnuplot? ( sci-visualization/gnuplot )
	hdf5? ( sci-libs/hdf5:= )
	imagemagick? ( media-gfx/graphicsmagick:=[cxx] )
	json? ( dev-libs/rapidjson )
	klu? ( sci-libs/klu:= )
	opengl? (
		media-libs/freetype:=
		media-libs/fontconfig:=
		virtual/glu
		x11-libs/gl2ps:=
	)
	portaudio? ( media-libs/portaudio )
	postscript? (
		app-text/epstool
		media-gfx/pstoedit
		>=media-gfx/fig2dev-3.2.9-r1
	)
	gui? (
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qthelp:5
			dev-qt/qtnetwork:5
			dev-qt/qtopengl:5
			dev-qt/qtprintsupport:5
			dev-qt/qtwidgets:5
			x11-libs/qscintilla:=[qt5]
		)
		qt6? (
			dev-qt/qtbase:6[gui,opengl,network,widgets]
			x11-libs/qscintilla:=[qt6]
		)
	)
	qhull? ( media-libs/qhull:= )
	qrupdate? ( sci-libs/qrupdate:= )
	readline? ( sys-libs/readline:= )
	sndfile? ( media-libs/libsndfile )
	sparse? (
		sci-libs/arpack:=
		sci-libs/camd:=
		sci-libs/ccolamd:=
		sci-libs/cholmod:=
		sci-libs/colamd:=
		sci-libs/cxsparse:=
		sci-libs/umfpack:=
	)
	spqr? ( sci-libs/spqr:= )
	ssl? (
		dev-libs/openssl:=
	)
	sundials? (
		klu? ( >=sci-libs/sundials-4:=[sparse] )
		!klu? ( >=sci-libs/sundials-4:= )
	)
	X? ( x11-libs/libX11:= )
"
RDEPEND="${COMMON_DEPS}
	java? ( >=virtual/jre-1.8:* )"
DEPEND="${COMMON_DEPS}
	java? ( >=virtual/jdk-1.8:* )"
BDEPEND="
	dev-util/gperf
	virtual/pkgconfig
	doc? (
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-plaingeneric
		dev-texlive/texlive-metapost
		virtual/latex-base
	)
	qt5? ( dev-qt/linguist-tools:5 )
	qrupdate? ( app-misc/pax-utils )
	sparse? ( app-misc/pax-utils )
"

# There are three ways to plot in Octave:
#
#   1. The old gnuplot renderer
#   2. The OpenGL renderer using the FLTK backend
#   3. The OpenGL renderer using the Qt backend
#
# It's possible to use the Qt GUI without OpenGL, but OpenGL rendering
# is all that FLTK is used for, so it doesn't make sense to enable
# USE=fltk without USE=opengl.
#
# Building without either USE=gnuplot or USE=opengl is technically legal,
# but will leave you unable to plot anything.
#
# Octave's FLTK support is unofficially deprecated, in the sense that
# you'll often get "why are you using FLTK?" in response to
# bugs. (Upstream bug 59321 for a random example.) In the future, it
# will probably make sense to merge USE=opengl and USE=X into USE=qt[56],
# dropping USE=fltk entirely.
REQUIRED_USE="
	?? ( qt5 qt6 )
	fltk? ( opengl X )
	gui? ( X )
	qt5? ( gui )
	qt6? ( gui )
	opengl? ( || ( fltk gui ) )
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.0-pkgbuilddir.patch
	"${FILESDIR}"/${PN}-9.2.0-omit-qtchooser-qtver.patch
)

src_prepare() {
	default

	# occasional fail on install, force regeneration (bug #401189)
	rm doc/interpreter/contributors.texi || die

	eautoreconf
}

src_configure() {
	# libstdc++ bug, bug #887815
	append-cxxflags -U_GLIBCXX_ASSERTIONS

	# Unfortunate dependency on mpi from hdf5 (bug #302621)
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc FC=mpif77 F77=mpif77

	# Tell autoconf where to find qt binaries, fix bug #837752
	local gui_with
	if use qt5 ; then
		export MOC="$(qt5_get_bindir)/moc" \
			UIC="$(qt5_get_bindir)/uic" \
			RCC="$(qt5_get_bindir)/rcc" \
			LRELEASE="$(qt5_get_bindir)/lrelease" \
			QCOLLECTIONGENERATOR="$(qt5_get_bindir)/qcollectiongenerator" \
			QHELPGENERATOR="$(qt5_get_bindir)/qhelpgenerator"
		gui_with="--with-qt=5"
	elif use qt6 ; then
		export MOC="$(qt6_get_bindir)/../libexec/moc" \
			UIC="$(qt6_get_bindir)/../libexec/uic" \
			RCC="$(qt6_get_bindir)/../libexec/rcc" \
			LRELEASE="$(qt6_get_bindir)/lrelease" \
			QHELPGENERATOR="$(qt6_get_bindir)/../libexec/qhelpgenerator"
		gui_with="--with-qt=6"
	else
		gui_with="--without-qt"
	fi

	# Some of these use_with flags are a bit mismatched. The configure
	# script offers only --without-foo, and detects "foo" automatically
	# unless --without-foo is specified. Passing --with-foo is not an
	# error, however, so it kind of works. We wind up with, for example,
	#
	# --with-sundials_ida (no-op) with USE="sundials"
	# --without-sundials_ida (disables it) with USE="-sundials"
	#
	local myeconfargs=(
		--localstatedir="${EPREFIX}/var/state/octave"
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--disable-64
		--enable-shared
		--with-z
		--with-bz2

		# bug #901965
		--without-libiconv-prefix
		--without-libreadline-prefix

		${gui_with}

		$(use_enable doc docs)
		$(use_enable java)
		$(use_enable json rapidjson)
		$(use_enable readline)
		$(use_with curl)
		$(use_with fftw fftw3)
		$(use_with fftw fftw3f)
		$(use_enable fftw fftw-threads)
		$(use_with glpk)
		$(use_with hdf5)
		$(use_with imagemagick magick GraphicsMagick++)
		$(use_with opengl)
		$(use_with fltk)
		$(use_with klu)
		$(use_with portaudio)
		$(use_with qhull qhull_r)
		$(use_with qrupdate)
		$(use_with sndfile)
		$(use_with sparse arpack)
		$(use_with sparse umfpack)
		$(use_with sparse colamd)
		$(use_with sparse ccolamd)
		$(use_with sparse cholmod)
		$(use_with sparse cxsparse)
		$(use_with spqr)
		$(use_with ssl openssl)
		$(use_with sundials sundials_ida)
		$(use_with sundials sundials_nvecserial)
		$(use_with X x)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Otherwise it will write to /var/cache/fonts/ and trip sandbox
	export VARTEXFONTS="${T}/fonts"

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
		# bug #566134, macros.texi is installed by make install if use doc
		insinto /usr/share/${PN}/${PV}/etc
		doins doc/interpreter/macros.texi
	fi

	use java && \
		java-pkg_regjar "${ED}/usr/share/${PN}/${PV}/m/java/octave.jar"

	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${PN}/${PV}" > 99octave || die
	doenvd 99octave

	find "${ED}" -type f -name '*.la' -delete || die
}
