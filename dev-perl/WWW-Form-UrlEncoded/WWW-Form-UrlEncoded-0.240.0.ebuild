# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KAZEBURO
DIST_VERSION=0.24
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="parser and builder for application/x-www-form-urlencoded"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="test +xs"

RDEPEND="
	virtual/perl-Exporter
	xs? ( >=dev-perl/WWW-Form-UrlEncoded-XS-0.190.0 )
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.500
	test? (
		>=dev-perl/JSON-2.0.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"
