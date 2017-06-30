# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.003009
inherit perl-module

DESCRIPTION="Use Cpanel::JSON::XS with a fallback to JSON::XS and JSON::PP"

SLOT="0"
KEYWORDS="amd64 ~arm ia64 ~ppc x86"
IUSE="test +xs"

# needs Scalar-Util
RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-JSON-PP-2.273.0
	virtual/perl-Scalar-List-Utils
	xs? (
		|| (
			>=dev-perl/Cpanel-JSON-XS-2.331.0
			>=dev-perl/JSON-XS-3.0.0
		)
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
