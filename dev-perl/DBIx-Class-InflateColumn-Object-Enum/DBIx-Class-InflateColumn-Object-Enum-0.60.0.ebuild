# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JMMILLS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Allows a DBIx::Class user to define a Object::Enum column"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/DBIx-Class
	dev-perl/Object-Enum
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/DBICx-TestDatabase
		virtual/perl-Test-Simple
	)
"
