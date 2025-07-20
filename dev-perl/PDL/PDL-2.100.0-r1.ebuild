# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.100
DIST_EXAMPLES=( "examples/*" )

inherit perl-module

DESCRIPTION="Perl Data Language for scientific computing"

LICENSE="|| ( Artistic GPL-1+ ) public-domain PerlDL"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"
IUSE="gd gsl hdf netpbm pgplot test"

# these need another round of review
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
	>=dev-perl/Devel-REPL-1.3.11
	|| ( dev-perl/Term-ReadLine-Perl dev-perl/Term-ReadLine-Gnu )
	netpbm? (
		media-libs/netpbm
		media-video/ffmpeg
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
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Warn
		dev-perl/Test-Deep
	)
"

# this is a temporary workaround until old PDL versions are gone
PDEPEND="
	gd?   ( dev-perl/PDL-IO-GD )
	gsl?  ( dev-perl/PDL-GSL )
	hdf?  ( dev-perl/PDL-IO-HDF )
"

mydoc="BUGS DEPENDENCIES DEVELOPMENT Known_problems MANIFEST* Release_Notes"

src_prepare() {
	perl-module_src_prepare
	find . -name Makefile.PL -exec \
		sed -i -e "s|/usr|${EPREFIX}/usr|g" {} \; || die
}

src_test() {
	MAKEOPTS+=" -j1" perl-module_src_test
}

src_install() {
	perl-module_src_install
	cp utils/scantree.pl "${D}"/${VENDOR_ARCH}/PDL/Doc || die
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
