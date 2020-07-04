# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.133
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Organize Data in Tables"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Text-Aligner-0.50.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( "t/author-pod-coverage.t" "t/author-pod-syntax.t" "t/release-cpan-changes.t" "t/style-trailing-space.t" )
