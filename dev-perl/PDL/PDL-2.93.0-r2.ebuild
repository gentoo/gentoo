# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.093
DIST_EXAMPLES=( "Example/*" )

inherit perl-module toolchain-funcs fortran-2

DESCRIPTION="Perl Data Language for scientific computing"

LICENSE="|| ( Artistic GPL-1+ ) public-domain PerlDL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+badval doc gd gsl hdf netpbm pdl2 pgplot test"

RDEPEND="
	sys-libs/ncurses:=
	app-arch/sharutils
	dev-perl/Astro-FITS-Header
	dev-perl/Convert-UU
	>=virtual/perl-Data-Dumper-2.121.0
	>=dev-perl/File-Map-0.570.0
	dev-perl/Filter
	dev-perl/File-Which
	>=dev-perl/Inline-0.830.0
	>=dev-perl/Inline-C-0.620.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Module-Compile
	>=dev-perl/OpenGL-0.700.0
	dev-perl/OpenGL-GLUT
	>=dev-perl/TermReadKey-2.340.0
	|| ( dev-perl/Term-ReadLine-Perl dev-perl/Term-ReadLine-Gnu )
	>=virtual/perl-Data-Dumper-2.121.0
	dev-perl/Pod-Parser
	>=virtual/perl-Text-Balanced-2.50.0
	>=dev-perl/ExtUtils-F77-1.260.0
	gd? ( media-libs/gd )
	gsl? ( sci-libs/gsl )
	hdf? (
		sci-libs/hdf
		dev-perl/Alien-HDF4
	)
	netpbm? (
		media-libs/netpbm
		media-video/ffmpeg
	)
	pdl2? (
		>=dev-perl/Devel-REPL-1.3.11
		|| ( dev-perl/Term-ReadLine-Perl dev-perl/Term-ReadLine-Gnu )
	)
	pgplot? ( dev-perl/PGPLOT )
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	${RDEPEND}
	>=virtual/perl-Carp-1.200.0
	>=dev-perl/Devel-CheckLib-1.10.0
	>=dev-perl/ExtUtils-Depends-0.402.0
	>=virtual/perl-ExtUtils-MakeMaker-7.120.0
	>=virtual/perl-ExtUtils-ParseXS-3.10.0
	>=dev-perl/ExtUtils-F77-1.130.0
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Warn
		dev-perl/Test-Deep
	)
"

mydoc="BUGS DEPENDENCIES DEVELOPMENT Known_problems MANIFEST* Release_Notes"

PATCHES=(
	# Respect user choice for fortran compiler+flags, add pic
	"${FILESDIR}"/${PN}-2.87.0-fortran.patch
)

pkg_setup() {
	perl_set_version
	fortran-2_pkg_setup
}

src_prepare() {
	perl-module_src_prepare
	find . -name Makefile.PL -exec \
		sed -i -e "s|/usr|${EPREFIX}/usr|g" {} \; || die
}

src_configure() {
	sed -i \
		-e '/USE_POGL/s/=>.*/=> 1,/' \
		-e "/WITH_3D/s/=>.*/=> 1,/" \
		-e "/HTML_DOCS/s/=>.*/=> $(use doc && echo 1 || echo 0),/" \
		-e "/WITH_BADVAL/s/=>.*/=> $(use badval && echo 1|| echo 0),/" \
		-e "/WITH_DEVEL_REPL/s/=>.*/=> $(use pdl2 && echo 1 || echo 0),/" \
		-e "/WITH_GSL/s/=>.*/=> $(use gsl && echo 1 || echo 0),/" \
		-e "/WITH_GD/s/=>.*/=> $(use gd && echo 1 || echo 0),/" \
		-e "/WITH_HDF/s/=>.*/=> $(use hdf && echo 1 || echo 0),/" \
		-e "/WITH_PGPLOT/s/=>.*/=> $(use pgplot && echo 1 || echo 0),/" \
		-e "/WITH_POSIX_THREADS/s/=>.*/=> 1,/" \
		-e "/WITH_PROJ/s/=>.*/=> $(echo 0),/" \
		perldl.conf || die

	export FC=$(tc-getF77)

	perl-module_src_configure
}

src_test() {
	MAKEOPTS+=" -j1" perl-module_src_test
}

src_install() {
	perl-module_src_install
	cp Doc/scantree.pl "${D}"/${VENDOR_ARCH}/PDL/Doc || die
}

pkg_postinst() {
	perl "${VENDOR_ARCH}/PDL/Doc/scantree.pl" || die
	elog "Building perldl.db done. You can recreate this at any time"
	elog "by running:"
	elog "perl ${VENDOR_ARCH}/PDL/Doc/scantree.pl"
}

pkg_prerm() {
	rm -rf "${EROOT}"/var/lib/pdl/html
	rm -f  "${EROOT}"/var/lib/pdl/{pdldoc.db,Index.pod}
}
