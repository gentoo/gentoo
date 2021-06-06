# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETJ
DIST_VERSION=0.9721
inherit perl-module

DESCRIPTION="Data structure and ops for directed graphs"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Heap-0.800.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/Set-Object-1.400.0
	>=virtual/perl-Storable-2.50.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Math-Complex
		>=virtual/perl-Test-Simple-0.820.0
	)
"
