# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Abstract Class::DBI's SQL with SQL::Abstract::Limit"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-DBI-0.900.0
	>=dev-perl/SQL-Abstract-Limit-0.120.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.320.0
		dev-perl/DBD-SQLite
	)
"
