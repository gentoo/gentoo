# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Set the Metrics::Any adapter for the program"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-perl/Module-Build
	test? ( virtual/perl-Test2-Suite )
"
