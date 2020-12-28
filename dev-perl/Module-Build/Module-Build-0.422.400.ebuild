# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEONT
DIST_VERSION=0.4224
inherit perl-module

DESCRIPTION="Build and install Perl modules"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-CPAN-Meta-2.142.60
	virtual/perl-Data-Dumper
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-ExtUtils-Install
	virtual/perl-ExtUtils-Manifest
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	>=virtual/perl-File-Spec-0.820.0
	virtual/perl-Getopt-Long
	>=virtual/perl-Module-Metadata-1.0.2
	>=virtual/perl-Perl-OSType-1
	>=virtual/perl-Test-Harness-3.290.0
	virtual/perl-Text-ParseWords
	>=virtual/perl-podlators-2.1.0
	>=virtual/perl-version-0.870.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-YAML-0.3.0
	>=virtual/perl-File-Temp-0.150.0
	>=virtual/perl-Parse-CPAN-Meta-1.440.100
	test? (
		>=virtual/perl-Test-Simple-0.490.0
	)
"
