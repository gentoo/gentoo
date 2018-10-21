# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.039
inherit perl-module

DESCRIPTION='A tiny replacement for Module::Build'
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~ppc-aix ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

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

DEPEND="
	${RDEPEND}
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Temp
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.88
		virtual/perl-XSLoader
	)
"

SRC_TEST="do parallel"

mytargets="install"
