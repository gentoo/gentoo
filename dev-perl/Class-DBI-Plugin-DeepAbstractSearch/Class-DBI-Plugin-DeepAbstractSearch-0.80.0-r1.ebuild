# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SRIHA
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="deep_search_where() method for Class::DBI"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Class-DBI-0.960.0
	>=dev-perl/Class-DBI-Plugin-0.20.0
	>=dev-perl/SQL-Abstract-1.180.0
	dev-perl/Class-DBI
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.320.0
	)
"
