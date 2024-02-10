# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SIXAPART
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Simple, transparent data interface, with caching"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/Class-Data-Inheritable
	dev-perl/Class-Trigger
	dev-perl/DBI
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Exception
		>=dev-perl/DBD-SQLite-1.110.0
		virtual/perl-version
	)
"
