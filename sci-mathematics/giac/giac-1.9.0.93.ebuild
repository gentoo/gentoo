# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg-utils

FETCH_P="${PN}_"$(ver_rs  3 '-')
MY_PV=$(ver_cut 1-3)
DESCRIPTION="A free C++ Computer Algebra System library and its interfaces"
HOMEPAGE="https://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="https://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"

# The licensing is explained in README. We disable or delete several
# bundled features (MicroPytho, QuickJS, FLTK, gl2ps) that are
# specifically mentioned there.
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS="el en es pt"
IUSE="ao doc +ecm examples gc +glpk gui test"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

# nauty and cliquer are automagical dependencies
RDEPEND="dev-libs/gmp:=[cxx(+)]
	dev-libs/mpfr:=
	dev-libs/ntl:=
	net-misc/curl
	sci-libs/mpfi
	sci-libs/gsl:=
	sci-mathematics/cliquer
	sci-mathematics/nauty
	sci-mathematics/pari:=[threads]
	sys-libs/readline:=
	virtual/lapack
	virtual/blas
	ao? ( media-libs/libao )
	ecm? ( sci-mathematics/gmp-ecm )
	gc? ( dev-libs/boehm-gc )
	glpk? ( sci-mathematics/glpk )
	gui? (
		media-libs/libpng:=
		x11-libs/fltk[opengl]
		x11-libs/gl2ps
	)"

DEPEND="${RDEPEND}"

BDEPEND="dev-tex/hevea
	virtual/pkgconfig
	app-alternatives/yacc"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.0.1-gsl_lapack.patch"
	"${FILESDIR}/${PN}-1.9.0.21-pari-2.15.patch"
	"${FILESDIR}/${PN}-1.9.0.67-system-gl2ps.patch"
	"${FILESDIR}/${P}-glibcxx-assertions.patch"
	"${FILESDIR}/${P}-no-fltk-buildfix.patch"
)

REQUIRED_USE="test? ( gui )"

# The mirror restriction is due to the French documentation for which
# "Other kind of redistributions require the consent of the copyright
# holder."
RESTRICT="!test? ( test ) mirror"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# giac-1.9.0.55 tries to compile a bundled version of FLTK for you
	# if you pass --enable-fltk but the system version isn't detected.
	# We make sure that cannot happen under any circumstances.
	rm fltk-1.3.8-source.tar.bz2 || die

	# similar deal with gl2ps
	rm src/gl2ps.[ch] || die

	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++14 # bug 788283

	if use gui; then
		append-cppflags -I$(fltk-config --includedir)
		append-lfs-flags

		# Get the big-L flags from fltk's LDFLAGS.
		append-ldflags $(fltk-config --ldflags | sed -e 's/\(-L\S*\)\s.*/\1/')
	fi

	# Using libsamplerate is currently broken
	#
	# The giac build system supports --docdir, but the path /usr/share/giac/doc
	# is hard-coded throughout the source code, so passing anything else to
	# ./configure --docdir just causes problems. Later, we'll put things right.
	#
	# micropython is for specific use in an upstream project, so is quickjs.
	# Note that disabling fltk is not a real option. It just skip autodetection
	# but doesn't disable compiling against fltk. png is needed as part of fltk
	# support.
	#
	# As of 1.9.0.25, --{en,dis}able-gui is no op. The only way to
	# disable the gui is though --disable-fltk.
	econf \
		--enable-gmpxx \
		--disable-samplerate \
		--disable-micropy \
		--disable-quickjs \
		--docdir="${EPREFIX}"/usr/share/giac/doc \
		$(use_enable gui fltk)  \
		$(use_enable gui png)  \
		$(use_enable ao) \
		$(use_enable ecm) \
		$(use_enable glpk) \
		$(use_enable gc)

}

src_install() {
	docompress -x "/usr/share/doc/${PF}/"{aide_cas,doc,examples}
	emake install DESTDIR="${D}"

	# Move all of /usr/share/giac (which contains only documentation) to
	# its /usr/share/doc/${PF} counterpart.
	dodir /usr/share/doc
	mv "${ED}"/usr/share/giac "${ED}/usr/share/doc/${PF}" || die

	# and create a symlink from the original location to the new one
	dosym "./doc/${PF}" /usr/share/giac

	# This is duplicated in ${ED}/usr/share/doc/${PF}/examples
	rm -r "${ED}/usr/share/doc/${PF}/doc/Exemples" || die

	# These aren't supposed to be installed at all.
	find "${ED}/usr/share/doc/${PF}" -type f -name 'Makefile*' -delete || die

	# The French docs are not freely licensed according to the README.
	rm -r "${ED}/usr/share/doc/${PF}/doc/fr" || die

	dodoc AUTHORS ChangeLog INSTALL NEWS README TROUBLES
	if ! use gui; then
		rm -rf \
			"${ED}"/usr/bin/x* \
			"${ED}"/usr/share/application-registry \
			"${ED}"/usr/share/applications \
			"${ED}"/usr/share/icons \
			|| die "failed to clean up fltk files"
	fi

	if ! use doc; then
		rm -r "${ED}/usr/share/doc/${PF}/doc" || die "failed to remove doc directory"
	else
		for lang in ${LANGS}; do
			if use l10n_$lang; then
				dosym ../aide_cas "/usr/share/doc/${PF}/doc/${lang}/aide_cas"
			else
				rm -r "${ED}/usr/share/giac/doc/${lang}" \
					|| die "failed to remove ${lang} documentation"
			fi
		done
	fi

	if ! use examples; then
		rm -r "${ED}/usr/share/doc/${PF}/examples" \
		   || die "failed to remove examples"
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
