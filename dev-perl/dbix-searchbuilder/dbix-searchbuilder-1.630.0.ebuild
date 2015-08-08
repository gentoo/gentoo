# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=DBIx-SearchBuilder
MODULE_AUTHOR=TSIBLEY
MODULE_VERSION=1.63
inherit perl-module

DESCRIPTION="Encapsulate SQL queries and rows in simple perl objects"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86"
IUSE="test"

RDEPEND="
	dev-perl/DBI
	dev-perl/DBIx-DBSchema
	dev-perl/Want
	>=dev-perl/Cache-Simple-TimedExpiry-0.210.0
	dev-perl/Clone
	dev-perl/Class-Accessor
	>=dev-perl/Class-ReturnValue-0.400.0
	>=dev-perl/capitalization-0.30.0
"
DEPEND="
	test? ( ${RDEPEND}
		dev-perl/DBD-SQLite
		>=virtual/perl-Test-Simple-0.520.0
	)
"

SRC_TEST="do"
