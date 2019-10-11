# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.43
inherit perl-module

DESCRIPTION="Test functions for exception based code"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=dev-perl/Sub-Uplevel-0.180.0
	virtual/perl-Test-Simple
	>=virtual/perl-Test-Harness-2.30.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
