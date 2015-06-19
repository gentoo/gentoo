# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/dbix-searchbuilder/dbix-searchbuilder-1.660.0.ebuild,v 1.4 2015/05/03 10:50:33 dilfridge Exp $

EAPI=5

MY_PN=DBIx-SearchBuilder
MODULE_AUTHOR=ALEXMV
MODULE_VERSION=1.66
inherit perl-module

DESCRIPTION="Encapsulate SQL queries and rows in simple Perl objects"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Cache-Simple-TimedExpiry-0.210.0
	>=dev-perl/capitalization-0.30.0
	>=dev-perl/Class-ReturnValue-0.400.0
	dev-perl/Class-Accessor
	dev-perl/Clone
	dev-perl/DBI
	dev-perl/DBIx-DBSchema
	dev-perl/Want
"
DEPEND="
	test? ( ${RDEPEND}
		>=virtual/perl-Test-Simple-0.520.0
		dev-perl/DBD-SQLite
		virtual/perl-File-Temp
	)
"

SRC_TEST="do"
