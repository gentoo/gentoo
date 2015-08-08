# Copyright 1999-2015 Gentoo Foundation
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
IUSE="curl doc fftw +glpk gnuplot gui hdf5 +imagemagick java jit opengl postscript
	+qhull +qrupdate readline +sparse static-libs X zlib"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	dev-libs/libpcre
	sys-libs/ncurses
	jit? ( <sys-devel/llvm-3.5 )
	virtual/lapack
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0 )
	glpk? ( sci-mathematics/glpk )
	gnuplot? ( sci-visualization/gnuplot )
	gui? ( x11-libs/qscintilla )
	hdf5? ( sci-libs/hdf5 )
	imagemagick? ( || (
			media-gfx/graphicsmagick[cxx]
			media-gfx/imagemagick[cxx] ) )
	opengl? (
		media-libs/freetype:2
		media-libs/fontconfig
		>=x11-libs/fltk-1.3:1[opengl]
		x11-libs/gl2ps
		virtual/glu )
	postscript? (
		app-text/epstool
		media-gfx/pstoedit
		media-gfx/transfig )
	qhull? ( media-libs/qhull )
	qrupdate? ( sci-libs/qrupdate )
	readline? ( sys-libs/readline:0 )
	sparse? (
		sci-libs/arpack
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/colamd
		sci-libs/cxsparse
		sci-libs/umfpack )
	X? ( x11-libs/libX11 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	qrupdate? ( app-misc/pax-utils )
	sparse? ( app-misc/pax-utils )
	doc? (
		virtual/latex-base
		dev-texlive/texlive-genericrecommended
		dev-texlive/texlive-metapost
		sys-apps/texinfo )
	dev-util/gperf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-3.8.0-pkgbuilddir.patch
	"${FILESDIR}"/${PN}-3.4.3-texi.patch
	"${FILESDIR}"/${PN}-3.8.0-imagemagick-configure.patch
	"${FILESDIR}"/${PN}-3.8.1-imagemagick.patch
	"${FILESDIR}"/${PN}-3.8.0-llvm-configure.patch
	"${FILESDIR}"/${PN}-3.8.0-disable-getcwd-path-max-test-as-it-is-too-slow.patch
)

pkg_pretend() {
	if use qrupdate || use sparse; then
		local blaslib=$($(tc-getPKG_CONFIG) --libs-only-l blas | sed -e 's@-l\([^ \t]*\)@lib\1@' | cut -d' ' -f 1)
		einfo "Checking dependencies are built with the same blas lib = ${blaslib}"
		local usr_lib="${ROOT}usr/$(get_libdir)"
		local libs=( )
		use qrupdate && libs+=( "${usr_lib}"/libqrupdate.so )
		use sparse && libs+=(
			"${usr_lib}"/libarpack.so
			"${usr_lib}"/libcholmod.so
			"${usr_lib}"/libspqr.so
			"${usr_lib}"/libumfpack.so
		)
		for i in ${libs[*]}
		do
			# Is it not linked with the current blas?  This check is not enough though, as
			# earlier versions of sci-libs/cholmod were not linked with blas, while as later
			# versions are if built with the lapack use flag.
			scanelf -n ${i} | grep -q "${blaslib}"
			if [[ $? -ne 0 ]]; then
				# Does it appear to be linked with some blas or lapack library?
				scanelf -n ${i} | egrep -q "blas|lapack"
				if [[ $? -eq 0 ]]; then
					eerror "*******************************************************************************"
					eerror "${i} must be rebuilt with ${blaslib}"
					eerror ""
					eerror "To check the libaries ${i} is currently built with:"
					eerror ""
					eerror "scanelf -n ${i}"
					eerror ""
					eerror "To find the package that needs to be rebuilt:"
					eerror ""
					eerror "equery belongs ${i}"
					eerror "*******************************************************************************"
					die
				fi
			fi
		done
	fi
}

src_prepare() {
	# nasty prefix hack for fltk:1 linking
	if use prefix && use opengl; then
		sed -i \
			-e "s:ldflags\`:ldflags\` -Wl,-rpath,${EPREFIX}/usr/$(get_libdir)/fltk-1:" \
			configure.ac
	fi
	if has_version ">=sys-devel/llvm-3.4"; then
		epatch "${FILESDIR}"/${PN}-3.8.0-llvm-3.4.patch
	fi
	# Fix bug 501756 - sci-mathematics/octave-3.8.0 LC_ALL=et_EE - octave.cc:485:56:
	# error: 'Fallow_noninteger_range_as_index' was not declared in this scope
	sed -e 's@A-Za-z0-9@[:alnum:]@g' \
		-e 's@A-Za-z@[:alpha:]@g' \
		-i "${S}/libinterp/mkbuiltins" \
		|| die "Could not patch ${S}/libinterp/mkbuiltins for some non-English locales"
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
		$(use_enable gui gui)
		$(use_enable jit)
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
	if use imagemagick; then
		if has_version media-gfx/graphicsmagick[cxx]; then
			myeconfargs+=( "--with-magick=GraphicsMagick" )
		else
			myeconfargs+=( "--with-magick=ImageMagick" )
		fi
	else
		myeconfargs+=( "--without-magick" )
	fi
	autotools-utils_src_configure
}

src_compile() {
	emake
	if use java || use jit ; then
		pax-mark m "${S}/src/.libs/octave-cli"
	fi
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc $(find doc -name \*.pdf)
	[[ -e test/fntests.log ]] && dodoc test/fntests.log
	use java && java-pkg_regjar "${ED}/usr/share/${PN}/${PV}/m/java/octave.jar"
	echo "LDPATH=${EROOT}usr/$(get_libdir)/${PN}/${PV}" > 99octave
	doenvd 99octave
}
