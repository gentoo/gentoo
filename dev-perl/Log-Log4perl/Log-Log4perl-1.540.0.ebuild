# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=1.54
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Log4j implementation for Perl"
HOMEPAGE="http://log4perl.sourceforge.net/"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=virtual/perl-File-Path-2.70.0
	>=virtual/perl-File-Spec-0.820.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.450.0 )
"
