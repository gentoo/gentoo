# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=0.23
DIST_AUTHOR=GOCCY
inherit perl-module

DESCRIPTION="Lexical Analyzer for Perl5"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-XSLoader-0.20.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	>=dev-perl/Module-Build-0.400.500
	>=dev-perl/Module-Build-XSUtil-0.20.0
	test? ( >=virtual/perl-Test-Simple-0.950.0 )
"
