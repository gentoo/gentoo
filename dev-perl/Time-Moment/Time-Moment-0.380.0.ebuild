# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.38
inherit perl-module

DESCRIPTION="Represents a date and time of day with an offset from UTC"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

PATCHES=(
	"${FILESDIR}/${DIST_VERSION}-makefilepl.patch"
)
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Time-HiRes
	>=virtual/perl-XSLoader-0.20.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-3.180.0
	test? (
		>=dev-perl/Test-Fatal-0.6.0
		>=dev-perl/Test-Number-Delta-1.60.0
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
