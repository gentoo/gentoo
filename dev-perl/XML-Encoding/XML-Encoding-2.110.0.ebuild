# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHAY
DIST_VERSION=2.11
inherit perl-module

DESCRIPTION="Perl Module that parses encoding map XML files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"

RDEPEND="
	>=dev-perl/XML-Parser-2.180.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-Test-Simple
	)
"
