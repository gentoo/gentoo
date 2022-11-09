# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="DateTime related constraints and coercions for Moose"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/DateTime-0.430.200
	>=dev-perl/DateTime-Locale-0.400.100
	>=dev-perl/DateTime-TimeZone-0.950.0
	>=dev-perl/Moose-0.410.0
	>=dev-perl/MooseX-Types-0.300.0
	>=dev-perl/namespace-clean-0.190.0
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		virtual/perl-Locale-Maketext
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-1.1.10
	)
"
