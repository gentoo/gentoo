# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AMBS
MODULE_VERSION=0.69
inherit perl-module

DESCRIPTION="Multiple virtual files in a single file"

SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test )
"

SRC_TEST="do parallel"
