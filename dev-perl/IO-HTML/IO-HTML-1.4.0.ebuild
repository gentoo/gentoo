# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CJM
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Open an HTML file with automatic charset detection"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Encode-2.100.0
	>=virtual/perl-Exporter-5.570.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.880.0
	)
"
