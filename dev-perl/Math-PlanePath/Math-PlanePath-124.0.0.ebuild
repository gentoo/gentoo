# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="KRYDE"
DIST_VERSION=124
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Mathematical paths through the 2-D plane"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="gmp test"
RESTRICT="!test? ( test )"

RDEPEND="gmp? ( dev-perl/Math-BigInt-GMP )
	dev-perl/Math-Libm
	dev-perl/Math-NumSeq
	>=dev-perl/constant-defer-5.0.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-Math-BigInt"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		dev-perl/Data-Float
		dev-perl/Math-BigInt-Lite
		dev-perl/Number-Fraction
	)
"
