# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=1.112
inherit perl-module

DESCRIPTION="Toolkit for implementing dependency systems"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Params-Util-0.310.0
	>=virtual/perl-Scalar-List-Utils-1.110.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Spec-0.800.0
		>=dev-perl/Test-ClassAPI-0.600.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"
