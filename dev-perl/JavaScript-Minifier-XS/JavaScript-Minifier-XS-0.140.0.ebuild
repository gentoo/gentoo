# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GTERMARS
DIST_VERSION=0.14

inherit perl-module

DESCRIPTION="XS based JavaScript minifier"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		>=dev-perl/Test-DiagINC-0.2.0
	)
"
