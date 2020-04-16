# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DOHERTY
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="release tests for your changelog"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	dev-perl/Data-Section
	>=dev-perl/Dist-Zilla-4
	dev-perl/Moose
	>=dev-perl/CPAN-Changes-0.190.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.940.0
		virtual/perl-autodie
	)
"
