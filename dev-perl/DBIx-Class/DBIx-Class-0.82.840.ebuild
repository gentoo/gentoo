# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RIBASUSHI
DIST_VERSION=0.082840
DIST_EXAMPLES=("examples/*")
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
	>=dev-perl/Class-Accessor-Grouped-0.100.120
	>=dev-perl/Class-C3-Componentised-1.0.900
	>=dev-perl/Class-Inspector-1.240.0
	>=dev-perl/Config-Any-0.200.0
	>=dev-perl/Context-Preserve-0.10.0
	>=dev-perl/Data-Dumper-Concise-2.20.0
	>=dev-perl/Data-Page-2.10.0
	>=dev-perl/DBI-1.570.0
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	virtual/perl-File-Path
	>=dev-perl/Hash-Merge-0.120.0
	>=dev-perl/MRO-Compat-0.120.0
	>=dev-perl/Math-Base36-0.70.0
	>=virtual/perl-Math-BigInt-1.80
	>=dev-perl/Module-Find-0.70.0
	>=dev-perl/Moo-2.0.0
	>=dev-perl/Path-Class-0.180.0
	>=dev-perl/SQL-Abstract-1.810.0
	>=virtual/perl-Scalar-List-Utils-1.160.0
	>=dev-perl/Scope-Guard-0.30.0
	>=dev-perl/Sub-Name-0.40.0
	>=virtual/perl-Text-Balanced-2.0.0
	>=dev-perl/Try-Tiny-0.70.0
	>=dev-perl/namespace-clean-0.240.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/DBD-SQLite-1.290.0
		>=virtual/perl-File-Temp-0.220.0
		>=dev-perl/Package-Stash-0.280.0
		>=dev-perl/Test-Deep-0.101.0
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.940.0
		>=dev-perl/Test-Warn-0.210.0
	)"
