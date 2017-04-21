# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SIXAPART
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Simple, transparent data interface, with caching"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Class-Trigger
	dev-perl/Class-Data-Inheritable
	dev-perl/Class-Accessor
	dev-perl/DBI
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Exception
		dev-perl/DBD-SQLite
		virtual/perl-version
	)
"
DIST_TEST="do"
