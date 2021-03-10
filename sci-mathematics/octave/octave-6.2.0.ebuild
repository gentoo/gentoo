# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic fortran-2 gnome2-utils java-pkg-opt-2 pax-utils toolchain-funcs xdg-utils

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="https://www.gnu.org/software/octave/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0/${PV}"
IUSE="curl doc fftw +glpk gnuplot gui hdf5 java libressl opengl
	portaudio postscript +qhull +qrupdate readline sndfile +sparse
	ssl static-libs sundials X zlib"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

# Although it is listed in INSTALL.OCTAVE as a build tool, Octave runs
# "makeinfo" from sys-apps/texinfo at runtime to convert its texinfo
# documentation to text (see scripts/help/help.m).
RDEPEND="
	app-arch/bzip2
	app-text/ghostscript-gpl
	sys-apps/texinfo
	dev-libs/libpcre:3=
	sys-libs/ncurses:0=
	sys-libs/zlib
	virtual/blas
	virtual/lapack
	curl? ( net-misc/curl:0= )
	fftw? ( sci-libs/fftw:3.0= )
	glpk? ( sci-mathematics/glpk:0= )
	gnuplot? ( sci-visualization/gnuplot )
	gui? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		x11-libs/qscintilla:=
	)
	hdf5? ( sci-libs/hdf5:0= )
	java? ( >=virtual/jre-1.6.0:* )
	opengl? (
		media-libs/freetype:2=
		media-libs/fontconfig:1.0=
		virtual/glu
		>=x11-libs/fltk-1.3:1=[opengl,xft]
		x11-libs/gl2ps:0=
	)
	portaudio? ( media-libs/portaudio )
	postscript? (
		app-text/epstool
		media-gfx/pstoedit
		media-gfx/transfig
	)
	qhull? ( media-libs/qhull:0= )
	qrupdate? ( sci-libs/qrupdate:0= )
	readline? ( sys-libs/readline:0= )
	sndfile? ( media-libs/libsndfile )
	sparse? (
		sci-libs/arpack:0=
		sci-libs/camd:0=
		sci-libs/ccolamd:0=
		sci-libs/cholmod:0=
		sci-libs/colamd:0=
		sci-libs/cxsparse:0=
		sci-libs/umfpack:0=
	)
	ssl? (
		 !libressl? ( dev-libs/openssl:0= )
		 libressl? ( dev-libs/libressl:0= )
	)
	sundials? ( >=sci-libs/sundials-4:0= )
	X? ( x11-libs/libX11:0= )"
DEPEND="${RDEPEND}
	dev-util/gperf
	virtual/pkgconfig
	doc? (
		dev-texlive/texlive-fontsrecommended
		dev-texlive/texlive-plaingeneric
		dev-texlive/texlive-metapost
		virtual/latex-base
	)
	gui? ( dev-qt/linguist-tools:5 )
	java? ( >=virtual/jdk-1.6.0 )
	qrupdate? ( app-misc/pax-utils )
	sparse? ( app-misc/pax-utils )"

# I'm not sure what the getcwd patch is intended to fix. That macro is
# part of gnulib, though, so if it's a serious problem then we should
# consult upstream about it.
PATCHES=(
	"${FILESDIR}"/${PN}-4.2.0-disable-getcwd-path-max-test-as-it-is-too-slow.patch
	"${FILESDIR}"/${PN}-5.1.0-pkgbuilddir.patch
	"${FILESDIR}"/${PN}-4.2.2-ncurses-pkgconfig.patch
)

src_prepare() {
	# nasty prefix hacks for fltk:1 linking
	if use prefix; then
		use opengl && append-ldflags -Wl,-rpath,"${EPREFIX}/usr/$(get_libdir)/fltk-1"
	fi

	# occasional fail on install, force regeneration (bug #401189)
	rm doc/interpreter/contributors.texi || die

	default
	eautoreconf
}

src_configure() {
	# unfortunate dependency on mpi from hdf5 (bug #302621)
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc FC=mpif77 F77=mpif77

	# Some of these use_with flags are a bit mismatched. The configure
	# script offers only --without-foo, and detects "foo" automatically
	# unless --without-foo is specified. Passing --with-foo is not an
	# error, however, so it kind of works. We wind up with, for example,
	#
	# --with-sundials_ida (no-op) with USE="sundials"
	# --without-sundials_ida (disables it) with USE="-sundials"
	#
	econf \
		--localstatedir="${EPREFIX}/var/state/octave" \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)" \
		--disable-64 \
		--disable-jit \
		--enable-shared \
		--with-z \
		--with-bz2 \
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
		$(use_with ssl openssl) \
		$(use_with portaudio) \
		$(use_with qhull) \
		$(use_with qrupdate) \
		$(use_with gui qt 5) \
		$(use_with sndfile) \
		$(use_with sparse arpack) \
		$(use_with sparse umfpack) \
		$(use_with sparse colamd) \
		$(use_with sparse ccolamd) \
		$(use_with sparse cholmod) \
		$(use_with sparse cxsparse) \
		$(use_with sundials sundials_ida) \
		$(use_with X x)
}

src_compile() {
	export VARTEXFONTS="${T}/fonts" # otherwise it will write to /var/cache/fonts/ and trip sandbox
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

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
