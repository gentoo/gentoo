# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=REHSACK
DIST_VERSION=1.410
inherit perl-module

DESCRIPTION="Small SQL parser and engine"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		dev-perl/Math-Base-Convert
		>=virtual/perl-Math-Complex-1.560.0
		>=dev-perl/Text-Soundex-3.40.0
	)
	virtual/perl-Carp
	>=dev-perl/Clone-0.300.0
	virtual/perl-Data-Dumper
	dev-perl/Module-Runtime
	>=dev-perl/Params-Util-1.0.0
	>=virtual/perl-Scalar-List-Utils-1.0.0
	virtual/perl-Text-Balanced
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Math-Base-Convert
		>=virtual/perl-Math-Complex-1.560.0
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		>=dev-perl/Text-Soundex-3.40.0
	)
"
