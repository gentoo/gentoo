# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BINGOS
DIST_VERSION=5.20210420
inherit perl-module

DESCRIPTION="Mapping Perl releases on CPAN to the location of the tarballs"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.470.0
	)
"
PERL_RM_FILES=( "t/author-pod-coverage.t" "t/author-pod-syntax.t" )
