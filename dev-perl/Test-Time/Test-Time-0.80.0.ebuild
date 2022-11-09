# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SATOH
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Overrides the time() and sleep() core functions for testing"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
"
