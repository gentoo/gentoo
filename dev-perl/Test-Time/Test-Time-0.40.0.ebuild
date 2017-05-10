# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SATOH
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Overrides the time() and sleep() core functions for testing"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/File-Slurp
	)
"

SRC_TEST="do parallel"
