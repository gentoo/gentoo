# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GUGOD
DIST_VERSION=0.84
inherit perl-module

DESCRIPTION='Manage perl installations in your $HOME'
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.860.0
	>=dev-perl/CPAN-Perl-Releases-3.660.0
	>=dev-perl/Capture-Tiny-0.360.0
	>=dev-perl/Devel-PatchPerl-1.520.0
	>=virtual/perl-File-Temp-0.230.400
	virtual/perl-JSON-PP
	>=virtual/perl-Pod-Parser-1.630.0
	>=dev-perl/local-lib-2.0.14
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=dev-perl/File-Which-1.210.0
		>=dev-perl/IO-All-0.510.0
		>=dev-perl/Path-Class-0.330.0

		>=dev-perl/Test-Exception-0.320.0
		>=dev-perl/Test-NoWarnings-1.40.0
		>=dev-perl/Test-Output-1.30.0
		>=virtual/perl-Test-Simple-1.1.2
		>=dev-perl/Test-Spec-0.470.0
		>=dev-perl/Test-TempDir-Tiny-0.16.0
	)
"
mydoc=("doc/notes.org")
