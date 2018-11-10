# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.11

inherit perl-module

DESCRIPTION="Install shared files"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

PERL_RM_FILES=( "Build.PL" ) # Using MBTiny is stupid this high up
RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Module-Metadata
		virtual/perl-Test-Simple
	)
"
DIST_TEST="do" # RT#111296

src_prepare() {
	PERL_MM_FALLBACK_SILENCE_WARNING=1 perl-module_src_prepare
}
