# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Read data out of the DATA section"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
