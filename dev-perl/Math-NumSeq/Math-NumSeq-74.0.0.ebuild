# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KRYDE
DIST_VERSION=74
DIST_EXAMPLES=("examples/other/*")
inherit perl-module

DESCRIPTION="number sequences (for example from OEIS)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Math-Factor-XS-0.400.0
	dev-perl/Math-Libm
	>=dev-perl/Math-Prime-XS-0.260.0
	virtual/perl-Module-Load
	>=dev-perl/Module-Pluggable-4.700.0
	dev-perl/Module-Util
	>=dev-perl/constant-defer-1.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Data-Float
		virtual/perl-Test
	)
"
