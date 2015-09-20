# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SATOH
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Overrides the time() and sleep() core functions for testing"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"

SRC_TEST="do parallel"
