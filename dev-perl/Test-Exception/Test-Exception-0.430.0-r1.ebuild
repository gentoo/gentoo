# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.43
inherit perl-module

DESCRIPTION="Test functions for exception based code"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/Sub-Uplevel-0.180.0
	virtual/perl-Test-Simple
	>=virtual/perl-Test-Harness-2.30.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
