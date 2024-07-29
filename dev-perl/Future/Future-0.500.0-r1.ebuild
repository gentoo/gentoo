# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="Represent an operation awaiting completion"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=dev-perl/Module-Build-0.400.400
	test? (
		>=virtual/perl-Test2-Suite-0.0.148
	)
"
