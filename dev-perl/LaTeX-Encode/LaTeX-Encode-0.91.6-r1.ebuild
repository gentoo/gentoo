# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EINHVERFR
DIST_VERSION=0.091.6
inherit perl-module

DESCRIPTION="Encode characters for LaTeX formatting"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/HTML-Parser
	dev-perl/Pod-LaTeX
	dev-perl/Readonly
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Carp-Always
	)
"
