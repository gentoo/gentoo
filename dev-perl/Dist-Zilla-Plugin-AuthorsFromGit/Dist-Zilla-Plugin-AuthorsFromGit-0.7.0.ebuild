# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKHUETTEL
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="Add per-file per-year copyright information"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/DateTime
	dev-perl/Dist-Zilla
	dev-perl/Git-Wrapper
	>=dev-perl/List-MoreUtils-0.400.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Moose
	dev-perl/Pod-Weaver
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
