# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GUGOD
DIST_VERSION=0.82
inherit perl-module

DESCRIPTION='Manage perl installations in your $HOME'
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/CPAN-Perl-Releases-3.240.0
	>=dev-perl/Capture-Tiny-0.360.0
	>=dev-perl/Devel-PatchPerl-1.400.0
	>=virtual/perl-Pod-Parser-1.630.0
	>=dev-perl/local-lib-2.0.14
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-File-Temp-0.230.400
	test? (
		>=dev-perl/IO-All-0.510.0
		>=dev-perl/Path-Class-0.330.0
		>=dev-perl/File-Which-1.210.0
		>=dev-perl/Test-Exception-0.320.0
		>=dev-perl/Test-NoWarnings-1.40.0
		>=dev-perl/Test-Output-1.30.0
		>=virtual/perl-Test-Simple-1.1.2
		>=dev-perl/Test-Spec-0.470.0
	)
"
mydoc=("doc/notes.org")
