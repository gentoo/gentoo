# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.02
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Low Level MultiPart MIME HTTP parser"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
	)
"
