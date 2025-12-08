# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="Override CORE::GLOBAL::require safely"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
