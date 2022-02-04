# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMTM
DIST_VERSION=1.25
DIST_EXAMPLES=( "bin/*" )
inherit perl-module

DESCRIPTION="Plucene - the Perl lucene port"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	>=dev-perl/Bit-Vector-Minimal-1.0.0
	virtual/perl-Carp
	>=dev-perl/Class-Accessor-0.180.0
	>=dev-perl/Class-Virtual-0.30.0
	virtual/perl-Encode
	virtual/perl-File-Spec
	virtual/perl-IO
	dev-perl/Lingua-Stem
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=virtual/perl-Memoize-1.10.0
	>=dev-perl/Tie-Array-Sorted-1.100.0
	virtual/perl-Time-Piece
	dev-perl/Encode-compat
	dev-perl/File-Slurp
	dev-perl/IO-stringy
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? ( >=virtual/perl-Test-Harness-2.300.0 )
"

PERL_RM_FILES=( t/99_pod.t )

src_install() {
	perl-module_src_install
	rm -rf "${ED}"/usr/bin
	rm -rf "${ED}"/usr/share/man
}
