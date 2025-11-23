# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.20250607
inherit perl-module

DESCRIPTION="Enable all of the features of Modern Perl with one import"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
