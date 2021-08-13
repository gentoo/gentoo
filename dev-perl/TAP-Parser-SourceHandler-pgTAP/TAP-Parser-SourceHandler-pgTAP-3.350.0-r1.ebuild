# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DWHEELER
DIST_VERSION=3.35
inherit perl-module

DESCRIPTION="Stream TAP from pgTAP test scripts"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	virtual/perl-Test-Harness
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
