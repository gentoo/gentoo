# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=2.97
DIST_EXAMPLES=( "bench" "scripts/time_trial.pl" "templates" )
inherit perl-module

DESCRIPTION="A Perl module to use HTML Templates"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~mips ppc ~ppc64 x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Digest-MD5
	>=virtual/perl-File-Spec-0.820.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/CGI
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/author-*.t
	perl-module_src_test
}
