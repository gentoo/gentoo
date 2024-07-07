# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBOOK
DIST_VERSION=0.003
inherit perl-module

DESCRIPTION="Utility functions for PPI"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>=dev-perl/B-Keywords-1.90.0
	virtual/perl-Exporter
	>=dev-perl/PPI-1.250.0
	virtual/perl-Scalar-List-Utils
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
	)
"
