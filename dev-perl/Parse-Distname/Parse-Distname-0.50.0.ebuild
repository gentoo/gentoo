# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Parse a distribution name"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-perl/ExtUtils-MakeMaker-CPANfile
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-JSON-PP
		dev-perl/Test-Differences
		>=dev-perl/Test-UseAllModules-0.170.0
	)
"
