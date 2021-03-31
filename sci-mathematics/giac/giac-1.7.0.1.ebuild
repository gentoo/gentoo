# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic xdg-utils

FETCH_P="${PN}_"$(ver_rs  3 '-')
MY_PV=$(ver_cut 1-3)
DESCRIPTION="A free C++ Computer Algebra System library and its interfaces"
HOMEPAGE="https://www-fourier.ujf-grenoble.fr/~parisse/giac.html"
SRC_URI="https://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/${FETCH_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LANGS="el en es pt"
IUSE="ao doc +ecm examples gc +glpk gui static-libs test"
for X in ${LANGS} ; do
	IUSE="${IUSE} l10n_${X}"
done

# nauty and cliquer are automagical dependencies
RDEPEND="dev-libs/gmp:=[cxx]
	sys-libs/readline:=
	gui? ( x11-libs/fltk
		media-libs/libpng:= )
	ao? ( media-libs/libao )
	dev-libs/mpfr:=
	sci-libs/mpfi
	sci-libs/gsl:=
	sci-mathematics/pari:=[threads]
	dev-libs/ntl:=
	virtual/lapack
	virtual/blas
	net-misc/curl
	sci-mathematics/cliquer
	sci-mathematics/nauty
	ecm? ( sci-mathematics/gmp-ecm )
	glpk? ( sci-mathematics/glpk )
	gc? ( dev-libs/boehm-gc )"

DEPEND="${RDEPEND}"

BDEPEND="dev-tex/hevea
	virtual/pkgconfig
	virtual/yacc"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.0.1-gsl_lapack.patch"
	"${FILESDIR}/${PN}-1.6.0-pari-2.11.patch"
)

REQUIRED_USE="test? ( gui )"

# The mirror restriction is due to the French documentation for which
# "Other kind of redistributions require the consent of the copyright
# holder."
RESTRICT="!test? ( test ) mirror"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare(){
	default
	eautoreconf
}

src_configure(){
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
	# micropython is for specific use in an upstream project
	econf \
		--enable-gmpxx \
		--disable-samplerate \
		--disable-micropy \
		--docdir=/usr/share/giac/doc \
		$(use_enable static-libs static) \
		$(use_enable gui)  \
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

pkg_postinst(){
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm(){
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
