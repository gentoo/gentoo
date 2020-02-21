# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NIGELM
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/HTML-Parser"
DEPEND="${REPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Differences
		dev-perl/Test-Memory-Cycle
	)"
