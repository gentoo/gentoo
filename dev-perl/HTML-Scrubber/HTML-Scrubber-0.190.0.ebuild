# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NIGELM
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="Perl extension for scrubbing/sanitizing html"

SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/HTML-Parser-3.470.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Differences
		dev-perl/Test-Memory-Cycle
		>=virtual/perl-Test-Simple-0.880.0
	)
"
