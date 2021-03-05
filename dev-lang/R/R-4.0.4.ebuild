# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 autotools flag-o-matic fortran-2 toolchain-funcs

# latest git commit for R bash completion: https://github.com/deepayan/rcompletion
BCPV=78d6830e28ea90a046da79a9b4f70c39594bb6d6

DESCRIPTION="Language and environment for statistical computing and graphics"
HOMEPAGE="http://www.r-project.org/"
SRC_URI="
	mirror://cran/src/base/R-4/${P}.tar.gz
	https://raw.githubusercontent.com/deepayan/rcompletion/${BCPV}/bash_completion/R -> ${PN}-${BCPV}.bash_completion"

LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cairo doc icu java jpeg lapack minimal nls openmp perl png prefix profile readline static-libs test tiff tk X"

# One test required profiling in v4.0.2, check the upstream bug:
#
#   https://bugs.r-project.org/bugzilla/show_bug.cgi?id=17836
#
REQUIRED_USE="png? ( || ( cairo X ) )
	jpeg? ( || ( cairo X ) )
	tiff? ( || ( cairo X ) )
	test? ( profile )
"

# At least one package installation in the test suite requires TeX,
# and will fail without it (bug #718056).
BDEPEND="virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-fontsrecommended
	)
	test? ( virtual/latex-base )"
DEPEND="
	app-arch/bzip2:0=
	app-arch/xz-utils:0=
	app-text/ghostscript-gpl
	dev-libs/libpcre2:=
	net-libs/libtirpc
	net-misc/curl
	virtual/blas:0
	|| ( sys-apps/coreutils app-misc/realpath )
	cairo? ( x11-libs/cairo:0=[X=] x11-libs/pango:0= )
	icu? ( dev-libs/icu:= )
	jpeg? ( virtual/jpeg:0 )
	lapack? ( virtual/lapack:0 )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng:0= )
	readline? ( sys-libs/readline:0= )
	tiff? ( media-libs/tiff:0= )
	tk? ( dev-lang/tk:0= )
	X? ( x11-libs/libXmu:0= x11-misc/xdg-utils )"

RDEPEND="${DEPEND}
	sys-libs/zlib:0[minizip]
	java? ( >=virtual/jre-1.5 )"

RESTRICT="minimal? ( test )
	!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.1-parallel.patch
	"${FILESDIR}"/${PN}-3.4.1-rmath-shared.patch
	"${FILESDIR}"/${PN}-3.6.2-no-LDFLAGS-in-libR-pkg-config.patch
	"${FILESDIR}"/${PN}-3.6.2-no-gzip-doc.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && use openmp; then
		FORTRAN_NEED_OPENMP=1
	fi
	fortran-2_pkg_setup
	filter-ldflags -Wl,-Bdirect -Bdirect
	# avoid using existing R installation
	unset R_HOME
	# Temporary fix for bug #419761
	if [[ ($(tc-getCC) == *gcc) && ($(gcc-version) == 4.7) ]]; then
		append-flags -fno-ipa-cp-clone
	fi
}

src_prepare() {
	default

	# fix packages.html for doc (gentoo bug #205103)
	sed -e "s:../../../library:../../../../$(get_libdir)/R/library:g" \
		-i src/library/tools/R/Rd.R || die

	# fix Rscript path when installed (gentoo bug #221061)
	sed -e "s:-DR_HOME='\"\$(rhome)\"':-DR_HOME='\"${EROOT}/usr/$(get_libdir)/${PN}\"':" \
		-i src/unix/Makefile.in || die "sed unix Makefile failed"

	# fix HTML links to manual (gentoo bug #273957)
	sed -e 's:\.\./manual/:manual/:g' \
		-i $(grep -Flr ../manual/ doc) || die "sed for HTML links failed"

	use lapack && \
		export LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"

	if use X; then
		export R_BROWSER="$(type -p xdg-open)"
		export R_PDFVIEWER="$(type -p xdg-open)"
	fi
	use perl && \
		export PERL5LIB="${S}/share/perl:${PERL5LIB:+:}${PERL5LIB}"

	# don't search /usr/local
	sed -i -e '/FLAGS=.*\/local\//c\: # removed by ebuild' configure.ac || die
	# Fix for Darwin (OS X)
	if use prefix; then
		if [[ ${CHOST} == *-darwin* ]] ; then
			sed -e 's:-install_name libR.dylib:-install_name ${libdir}/R/lib/libR.dylib:' \
				-e 's:-install_name libRlapack.dylib:-install_name ${libdir}/R/lib/libRlapack.dylib:' \
				-e 's:-install_name libRblas.dylib:-install_name ${libdir}/R/lib/libRblas.dylib:' \
				-e "/SHLIB_EXT/s/\.so/.dylib/" \
				-i configure.ac || die
			# sort of "undo" 2.14.1-rmath-shared.patch
			sed -e "s:-Wl,-soname=libRmath.so:-install_name ${EROOT}/usr/$(get_libdir)/libRmath.dylib:" \
				-i src/nmath/standalone/Makefile.in || die
		else
			append-ldflags -Wl,-rpath="${EROOT}/usr/$(get_libdir)/R/lib"
		fi
	fi
	AT_M4DIR=m4
	eautoreconf
}

src_configure() {
	#	--with-system-tre \
	# tre is patched from upstream
	econf \
		--enable-byte-compiled-packages \
		--enable-R-shlib \
		--disable-R-framework \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		rdocdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable java) \
		$(use_enable nls) \
		$(use_enable openmp) \
		$(use_enable profile R-profiling) \
		$(use_enable profile memory-profiling) \
		$(use_enable static-libs static) \
		$(use_enable static-libs R-static-lib) \
		$(use_with cairo) \
		$(use_with icu ICU) \
		$(use_with jpeg jpeglib) \
		$(use_with lapack) \
		$(use_with !minimal recommended-packages) \
		$(use_with png libpng) \
		$(use_with readline) \
		$(use_with tiff libtiff) \
		$(use_with tk tcltk) \
		$(use_with tk tk-config "${EPREFIX}"/usr/$(get_libdir)/tkConfig.sh) \
		$(use_with tk tcl-config "${EPREFIX}"/usr/$(get_libdir)/tclConfig.sh) \
		$(use_with X x)
}

src_compile() {
	export VARTEXFONTS="${T}/fonts"
	emake AR="$(tc-getAR)"
	emake -C src/nmath/standalone \
		shared $(use static-libs && echo static) AR="$(tc-getAR)"
	use doc && emake info pdf
}

src_install() {
	default
	emake -j1 -C src/nmath/standalone DESTDIR="${D}" install

	if use doc; then
		emake DESTDIR="${D}" install-info install-pdf
		dosym ../manual /usr/share/doc/${PF}/html/manual
	fi

	cat > 99R <<-EOF
		LDPATH=${EROOT}/usr/$(get_libdir)/${PN}/lib
		R_HOME=${EROOT}/usr/$(get_libdir)/${PN}
	EOF
	doenvd 99R
	newbashcomp "${DISTDIR}"/${PN}-${BCPV}.bash_completion ${PN}
	# The buildsystem has a different understanding of install_names than
	# we require.  Since it builds modules like shared objects (wrong), many
	# objects (all modules) get an incorrect install_name.  Fixing the build
	# system here is not really trivial.
	if [[ ${CHOST} == *-darwin* ]] ; then
		local mod
		pushd "${ED}"/usr/$(get_libdir)/R > /dev/null
		for mod in $(find . -name "*.dylib") ; do
			mod=${mod#./}
			install_name_tool -id "${EPREFIX}/usr/$(get_libdir)/R/${mod}" \
				"${mod}"
		done
		popd > /dev/null
	fi

	# Users are encouraged to access some of the the R documentation
	# interactively, through functions like "contributors()" that
	# tries to open the "AUTHORS" file. Other files can be accessed
	# by name with RShowDoc(), and the documentation for e.g. license()
	# and RShowDoc() suggests a few of these names. Here we try to
	# collect as many names as possible that a user might actually
	# try to view through R, because if we don't decompress them,
	# then R doesn't know what to do with 'em. Bug #556706.
	INTERACTIVE_DOCS=(
		AUTHORS
		COPYING
		FAQ
		NEWS
		THANKS
	)

	# Other data sources that are shipped as "documentation," but which
	# need to be accessible via their original unmolested filenames.
	INTERACTIVE_DATA=(
		BioC_mirrors.csv
		CRAN_mirrors.csv
		KEYWORDS.db
		NEWS.rds
	)

	NOCOMPRESS_DOCS=( "${INTERACTIVE_DOCS[@]}" "${INTERACTIVE_DATA[@]}" )

	for f in "${NOCOMPRESS_DOCS[@]}"; do
		docompress -x "/usr/share/doc/${PF}/${f}"
	done
}

pkg_postinst() {
	if use java; then
		einfo "Re-initializing java paths for ${P}"
		R CMD javareconf
	fi
}
