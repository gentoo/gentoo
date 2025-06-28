# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MINIMAL
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Convert POD to Github's specific markdown"
SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos"

RDEPEND="
	dev-perl/Pod-Markdown
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
