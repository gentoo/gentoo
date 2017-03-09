# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSCHILLI
MODULE_VERSION=1.46
inherit perl-module

DESCRIPTION="Log4j implementation for Perl"
HOMEPAGE="http://log4perl.sourceforge.net/"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Path-2.60.600
	>=virtual/perl-File-Spec-0.820.0
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.450.0 )
"

SRC_TEST="do"
