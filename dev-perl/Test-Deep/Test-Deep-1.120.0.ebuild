# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.120
inherit perl-module

DESCRIPTION="Extremely flexible deep comparison testing"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.90.0
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		|| (
			>=virtual/perl-Test-Simple-1.1.10
			( <virtual/perl-Test-Simple-1.1.10 >=dev-perl/Test-Tester-0.40.0 )
		)
	)
"
