# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.20161202
inherit perl-module

DESCRIPTION="Perl extension for emulating troublesome interfaces"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/UNIVERSAL-isa-1.201.106.140
	>=dev-perl/UNIVERSAL-can-1.201.106.170
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/CGI-4.150.0
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-Exception-0.310.0
		>=dev-perl/Test-Warn-0.230.0
	)
"
