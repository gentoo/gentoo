# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PJCJ
DIST_VERSION=1.44
inherit perl-module

DESCRIPTION="Code coverage metrics for Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Storable
	>=dev-perl/HTML-Parser-3.690.0
	!minimal? (
		dev-perl/Browser-Open
		dev-perl/Capture-Tiny
		dev-perl/Class-XSAccessor
		dev-perl/HTML-Parser
		>=dev-perl/JSON-MaybeXS-1.3.3
		dev-perl/Moo
		dev-perl/Parallel-Iterator
		>=dev-perl/Perl-Tidy-20060719.0.0
		>=dev-perl/Pod-Coverage-0.220.0
		dev-perl/Sereal-Decoder
		dev-perl/Sereal-Encoder
		>=dev-perl/PPI-HTML-1.70.0
		>=dev-perl/Template-Toolkit-2.0.0
		dev-perl/Test-Differences
		dev-perl/namespace-clean
	)
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Math-BigInt
		>=virtual/perl-Test-Simple-0.880.0
	)
"
