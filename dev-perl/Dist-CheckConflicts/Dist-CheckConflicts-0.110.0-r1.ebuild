# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOY
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Declare version conflicts for your dist"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/Module-Runtime-0.9.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.88
	)
"
