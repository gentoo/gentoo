# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Declare class attributes Moose-style"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Moose-2.0.0
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/namespace-autoclean-0.110.0
	>=dev-perl/namespace-clean-0.200.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		>=dev-perl/Test-Requires-0.50.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"
