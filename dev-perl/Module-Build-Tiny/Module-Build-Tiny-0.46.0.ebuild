# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.046
inherit perl-module

DESCRIPTION="Tiny replacement for Module::Build"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-CPAN-Meta
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/ExtUtils-Config-0.3.0
	>=dev-perl/ExtUtils-Helpers-0.20.0
	virtual/perl-ExtUtils-Install
	>=dev-perl/ExtUtils-InstallPaths-0.2.0
	virtual/perl-ExtUtils-ParseXS
	virtual/perl-File-Path
	virtual/perl-File-Spec
	>=virtual/perl-Getopt-Long-2.360.0
	>=virtual/perl-JSON-PP-2.0.0
	virtual/perl-podlators
	virtual/perl-Test-Harness
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Temp
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.88
		virtual/perl-XSLoader
	)
"

mytargets="install"
