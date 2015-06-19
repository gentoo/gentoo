# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Class/DBIx-Class-0.82.700.ebuild,v 1.1 2014/07/06 19:23:08 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RIBASUSHI
MODULE_VERSION=0.08270
inherit perl-module

DESCRIPTION="Extensible and flexible object <-> relational mapper"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test admin admin_script deploy replicated"

RDEPEND_MOOSE_BASIC="
	>=dev-perl/Moose-0.980.0
	>=dev-perl/MooseX-Types-0.210.0
"
RDEPEND_ADMIN_BASIC="
	>=dev-perl/JSON-Any-1.220.0
	>=dev-perl/MooseX-Types-JSON-0.20.0
	>=dev-perl/MooseX-Types-Path-Class-0.50.0
	>=dev-perl/namespace-autoclean-0.90.0
"

#	>=dev-perl/Class-DBI-Plugin-DeepAbstractSearch-0.08
#	dev-perl/Class-Trigger
#	>=dev-perl/DBIx-ContextualFetch-1.03
#	>=dev-perl/Date-Simple-3.03
#	dev-perl/DateTime-Format-MySQL
#	dev-perl/DateTime-Format-Pg
#	dev-perl/DateTime-Format-SQLite
#	dev-perl/DateTime-Format-Strptime
#	dev-perl/Devel-Cycle
#	dev-perl/Time-Piece-MySQL

RDEPEND="
	admin? (
		${RDEPEND_MOOSE_BASIC}
		${RDEPEND_ADMIN_BASIC}
	)
	admin_script? (
		${RDEPEND_MOOSE_BASIC}
		${RDEPEND_ADMIN_BASIC}
		>=dev-perl/Getopt-Long-Descriptive-0.81.0
		>=dev-perl/Text-CSV-1.160.0
	)
	deploy? (
		>=dev-perl/SQL-Translator-0.110.60
	)
	replicated? (
		${RDEPEND_MOOSE_BASIC}
		>=dev-perl/Hash-Merge-0.120.0
	)
	>=dev-perl/DBD-SQLite-1.290.0
	>=dev-perl/Carp-Clan-6.00
	>=dev-perl/Class-Accessor-Grouped-0.100.90
	>=dev-perl/Class-C3-Componentised-1.0.900
	>=dev-perl/Class-Inspector-1.240.0
	>=dev-perl/Config-Any-0.200.0
	dev-perl/Data-Compare
	>=dev-perl/Data-Page-2.10.0
	>=dev-perl/DBI-1.609.0
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	>=virtual/perl-File-Path-2.80.0
	dev-perl/Hash-Merge
	>=dev-perl/MRO-Compat-0.120.0
	>=dev-perl/Math-Base36-0.70.0
	>=virtual/perl-Math-BigInt-1.80
	>=dev-perl/Module-Find-0.70.0
	>=dev-perl/Moo-0.1.6
	>=dev-perl/Path-Class-0.180.0
	>=dev-perl/SQL-Abstract-1.730.0
	>=dev-perl/Sub-Name-0.40.0
	>=dev-perl/Data-Dumper-Concise-2.20.0
	>=dev-perl/Scope-Guard-0.30.0
	dev-perl/Context-Preserve
	>=dev-perl/Try-Tiny-0.70.0
	>=dev-perl/namespace-clean-0.240.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-File-Temp-0.22
		>=dev-perl/Package-Stash-0.280.0
		>=dev-perl/Test-Exception-0.31
		>=dev-perl/Test-Warn-0.21
		>=virtual/perl-Test-Simple-0.94
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
