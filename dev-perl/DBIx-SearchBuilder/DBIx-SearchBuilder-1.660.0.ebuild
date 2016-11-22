# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

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

src_prepare() {
	use test && perl_rm_files t/pod.t
	perl-module_src_test
}
