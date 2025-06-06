# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PREACTION
DIST_VERSION=1.718
inherit perl-module

DESCRIPTION="Bringing loggers and listeners together"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="minimal"

# Test::Builder needed for Log/Any/Adapter/Test.pm
# constant -> perl
BDEPEND="
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
	)
"
