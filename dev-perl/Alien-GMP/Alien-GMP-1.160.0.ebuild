# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=1.16
DIST_AUTHOR=PLICEASE
inherit perl-module

DESCRIPTION="Alien package for the GNU Multiple Precision library"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Alien-Build-1.460.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Alien-Build-0.320.0
	dev-perl/Devel-CheckLib
	virtual/perl-ExtUtils-CBuilder
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	test? (
		>=dev-perl/Test2-Suite-0.0.60
	)
"
