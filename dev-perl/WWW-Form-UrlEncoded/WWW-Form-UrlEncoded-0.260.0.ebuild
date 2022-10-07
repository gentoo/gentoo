# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.26
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="parser and builder for application/x-www-form-urlencoded"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="+xs"

RDEPEND="
	virtual/perl-Exporter
	xs? ( >=dev-perl/WWW-Form-UrlEncoded-XS-0.190.0 )
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.500
	test? (
		>=virtual/perl-JSON-PP-2.0.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"
