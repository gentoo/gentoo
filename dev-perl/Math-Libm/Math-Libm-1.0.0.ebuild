# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="DSLEWART"
DIST_VERSION="1.00"
inherit perl-module

DESCRIPTION="wrapper to libm functions"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-AutoLoader
	virtual/perl-Carp"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
