# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DJERIUS
DIST_VERSION=0.43
inherit perl-module

DESCRIPTION="Extract data from an HTML table"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-perl/HTML-Parser-3.260.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-0.320.0
	)
"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )
