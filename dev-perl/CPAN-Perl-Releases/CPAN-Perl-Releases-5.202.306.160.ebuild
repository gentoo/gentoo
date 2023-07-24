# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=5.20230616
inherit perl-module

DESCRIPTION="Mapping Perl releases on CPAN to the location of the tarballs"

SLOT="0"
KEYWORDS="~amd64 x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.470.0
	)
"

PERL_RM_FILES=( "t/author-pod-coverage.t" "t/author-pod-syntax.t" )
