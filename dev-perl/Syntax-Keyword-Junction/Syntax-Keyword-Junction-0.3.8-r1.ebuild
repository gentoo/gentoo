# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FREW
DIST_VERSION=0.003008
inherit perl-module

DESCRIPTION="Perl6 style Junction operators in Perl5"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.6
	virtual/perl-parent
	dev-perl/syntax
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Requires-0.70.0
	)
"
PERL_RM_FILES=( "t/release-pod-syntax.t" )
