# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Create DateTime objects with sub-second current time resolution"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-perl/DateTime
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
