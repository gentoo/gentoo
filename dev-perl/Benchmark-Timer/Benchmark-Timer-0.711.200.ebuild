# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCOPPIT
DIST_VERSION=0.7112
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl code benchmarking tool"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-0.7112-noauthortests.patch"
	"${FILESDIR}/${PN}-0.7112-relocateexample.patch"
)
PERL_RM_FILES=(
	"inc/Module/Install/AutomatedTester.pm"
	"inc/Module/Install/Bugtracker.pm"
	"inc/Module/Install/GithubMeta.pm"
	"inc/Module/Install/PRIVATE/Enable_Verbose_CPAN_Testing.pm"
	"inc/Module/Install/StandardTests.pm"
	"inc/URI/Escape.pm"
	"private-lib/Module/Install/PRIVATE/Enable_Verbose_CPAN_Testing.pm"
)
RDEPEND="
	dev-perl/Statistics-TTest
	virtual/perl-Time-HiRes
"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( virtual/perl-Test-Simple )
"
