# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="No line insertion and does Package version with our"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/MooseX-Types-Perl
	dev-perl/PPI
	dev-perl/namespace-autoclean
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Path-Tiny
		virtual/perl-Test-Simple
		dev-perl/Test-Version
	)
"
src_test() {
	perl_rm_files t/author-*.t t/release-*.t
	perl-module_src_test
}
