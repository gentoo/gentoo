# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Deep/Test-Deep-0.115.0.ebuild,v 1.2 2015/06/13 11:27:16 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.115
inherit perl-module

DESCRIPTION="Test::Deep - Extremely flexible deep comparison"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.90.0
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		>=dev-perl/Test-NoWarnings-0.20.0
		|| ( >=virtual/perl-Test-Simple-1.1.10 >=dev-perl/Test-Tester-0.40.0 )
	)
"

SRC_TEST="do"
