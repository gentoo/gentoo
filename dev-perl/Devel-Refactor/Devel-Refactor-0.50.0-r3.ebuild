# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SSOTKA
DIST_VERSION=0.05
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for refactoring Perl code"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.50.0-perl526.patch"
)
