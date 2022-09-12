# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ROKR
DIST_VERSION=0.089
inherit perl-module

DESCRIPTION="Parse a date/time string using the best method available"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DateTime
	dev-perl/TimeDate
	dev-perl/DateTime-Format-Flexible
	dev-perl/DateTime-Format-ICal
	dev-perl/DateTime-Format-Natural
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.31
	test? (
		dev-perl/Test-Most
	)
"
