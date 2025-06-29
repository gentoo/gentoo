# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NIGELM
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"

SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/HTML-Parser-3.470.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Differences
		dev-perl/Test-Memory-Cycle
		>=virtual/perl-Test-Simple-0.880.0
	)
"
