# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHILLI
DIST_VERSION=1.49
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Log4j implementation for Perl"
HOMEPAGE="http://log4perl.sourceforge.net/"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
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
